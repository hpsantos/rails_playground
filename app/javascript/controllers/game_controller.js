import { Controller } from "@hotwired/stimulus";

const PLAYER_CLASSES = {
  red: "player-red",
  blue: "player-blue",
  green: "player-green",
};

export default class extends Controller {
  connect() {
    const playersData = JSON.parse(this.data.get("players"));

    this.bindKeydownEvents();
    this.bindWebsocket();

    this.updateGridState(playersData);
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
        this.updateGridState(message.players);
      }
    });
  }

  bindKeydownEvents() {
    const playerId = this.data.get("player_id");

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
            player: playerId,
          }),
        });
      }
    });
  }

  updateGridState(players) {
    // Clean old players position
    this.element.querySelectorAll(".player").forEach((e) => e.remove());

    for (var i = 0; i < players.length; i++) {
      const player = players[i];
      const roverRow = this.element.querySelector(
        `.grid-row:nth-child(${player.y + 1})`
      );
      const roverCell = roverRow.querySelector(
        `.grid-cell:nth-child(${player.x + 1})`
      );
      // Draw new player position
      const playerCell = document.createElement("div");
      playerCell.classList.add("player", PLAYER_CLASSES[player.name]);
      roverCell.appendChild(playerCell);
    }
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
