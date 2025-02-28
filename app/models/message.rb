class Message < ApplicationRecord
  belongs_to :player
  belongs_to :game

  after_create :broadcast_message

  def broadcast_message
    broadcast_append_to [ game, "messages" ], target: "game-messages", partial: "rover/game/message",
      locals: { messages: game.messages }
  end
end
