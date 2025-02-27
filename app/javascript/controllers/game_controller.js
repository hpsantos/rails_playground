import { Controller } from "@hotwired/stimulus";
import { createVehicle } from "utils/vehicles";

const PLAYER_COLORS = {
  red: "#BB5555",
  blue: "#5555BB",
  green: "#55AA55",
};

const DIRECTION_DEGREES = {
  up: 0,
  right: 90,
  down: 180,
  left: 270,
};

let previous_direction = undefined;

export default class extends Controller {
  connect() {
    const players = JSON.parse(this.data.get("players"));
    const game = JSON.parse(this.data.get("game"));

    this.bindKeydownEvents();
    this.bindWebsocket();

    this.updateGridState(game, players);
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
      if (message && message.type === "player_update") {
        this.updateGridState(message.game, message.players);
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

  updateGridState(game, players) {
    for (var i = 0; i < players.length; i++) {
      const player = players[i];
      const playerTop = (player.y / (game.cols - 1)) * 100;
      const playerLeft = (player.x / (game.rows - 1)) * 100;
      const vehicle = this.findOrCreateVehicle(player);

      vehicle.style = `top:${playerTop}%;left:${playerLeft}%;transform:rotate(${
        DIRECTION_DEGREES[player.direction]
      }deg);`;
    }
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
