class Booster < ApplicationRecord
  belongs_to :game

  after_commit :broadcast_update, on: %i[create destroy]

  def broadcast_update
    ActionCable.server.broadcast("game_channel", {
      type: "game_update",
      game: game,
      boosters: game.boosters,
      players: game.players
    })
  end
end
