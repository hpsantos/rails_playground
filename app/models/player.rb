class Player < ApplicationRecord
  belongs_to :game

  validates :name, presence: true, uniqueness: true
  validates :game_id, uniqueness: { scope: %i[name] }
  validates :x, presence: true
  validates :y, presence: true
  after_save :broadcast_update

  def broadcast_update
    Rails.logger.info("\n\nBroadcasting update for player #{id} in game #{game_id}\n\n")
    ActionCable.server.broadcast("game_channel", {
      type: "player_update",
      game: game,
      players: game.players
    })
  end

  def process_command(command)
    case command
    when "up"
      self.y -= 1
    when "down"
      self.y += 1
    when "left"
      self.x -= 1
    when "right"
      self.x += 1
    end
  end

  def process_command!(command)
    process_command(command)
    save
  end

  def self.available_players
    %w[red blue green]
  end
end
