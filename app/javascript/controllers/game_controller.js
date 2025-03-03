import { Controller } from "@hotwired/stimulus";
import { createVehicle } from "utils/vehicles";

const PLAYER_COLORS = {
  red: "#BB5555",
  blue: "#5555BB",
  green: "#55AA55",
};

export default class extends Controller {
  connect() {
    const players = JSON.parse(this.data.get("players"));
    const game = JSON.parse(this.data.get("game"));
    const boosters = JSON.parse(this.data.get("boosters"));

    this.bindKeydownEvents();
    this.bindWebsocket();

    this.updateGridState(game, players, boosters);
  }

  bindWebsocket() {
    const socket = new WebSocket("/cable");
    // Connection opened
    socket.addEventListener("open", (event) => {
      const msg = {
        command: "subscribe",
        identifier: JSON.stringify({
          channel: "GameChannel",
        }),
      };
      socket.send(JSON.stringify(msg));
    });
    // Listen for messages
    socket.addEventListener("message", (event) => {
      const { message } = JSON.parse(event.data);
      if (message && message.type === "game_update") {
        message.players.forEach((player) => {
          player.name === "green" && console.log(player);
        });
        this.updateGridState(message.game, message.players, message.boosters);
      }
    });
  }

  bindKeydownEvents() {
    const current_player_id = this.data.get("current_player_id");

    addEventListener("keydown", (event) => {
      const command = this.getCommand(event.key);
      if (command) {
        fetch("/rover/game", {
          method: "PUT",
          headers: {
            "Content-type": "application/json",
          },
          body: JSON.stringify({
            command,
            player: current_player_id,
          }),
        });
      }
    });
  }

  updateGridState(game, players, boosters) {
    players.forEach((player) => {
      const playerTop = (player.y / (game.cols - 1)) * 100;
      const playerLeft = (player.x / (game.rows - 1)) * 100;
      const vehicle = this.findOrCreateVehicle(player);

      vehicle.style = `top:${playerTop}%;left:${playerLeft}%;transform:rotate(${player.rotation}deg);`;
    });

    const existingBoosters = this.element.querySelectorAll(".booster");
    existingBoosters.forEach((booster) => {
      booster.remove();
    });

    boosters.forEach((booster) => {
      const boosterTop = (booster.y / (game.cols - 1)) * 100;
      const boosterLeft = (booster.x / (game.rows - 1)) * 100;
      const boosterElem = this.createBooster(booster);

      boosterElem.style = `top:${boosterTop}%;left:${boosterLeft}%;);`;
    });
  }

  findOrCreateVehicle(player) {
    const existingVehicle = this.element.querySelectorAll(
      ".player-" + player.name
    );
    if (existingVehicle.length > 0) {
      return existingVehicle[0];
    }

    const vehicle = createVehicle(PLAYER_COLORS[player.name], player.direction);
    vehicle.classList.add("player", "player-" + player.name);

    this.element.appendChild(vehicle);
    return vehicle;
  }

  createBooster(booster) {
    const boosterElem = document.createElement("div");
    boosterElem.classList.add(
      "booster",
      "booster-id-" + booster.id,
      "booster-" + booster.value
    );
    this.element.appendChild(boosterElem);
    return boosterElem;
  }

  getCommand(key) {
    switch (key) {
      case "ArrowUp":
        return "up";
      case "ArrowDown":
        return "down";
      case "ArrowLeft":
        return "left";
      case "ArrowRight":
        return "right";
    }
  }
}
