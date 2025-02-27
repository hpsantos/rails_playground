class Player < ApplicationRecord
  belongs_to :game

  validates :name, presence: true, uniqueness: true
  validates :game_id, uniqueness: { scope: %i[name] }
  validates :x, presence: true
  validates :y, presence: true
  after_save :broadcast_update

  enum :direction, { neutral: 0, up: 1, right: 2, down: 3, left: 4 }

  def broadcast_update
    ActionCable.server.broadcast("game_channel", {
      type: "player_update",
      game: game,
      players: game.players
    })
  end

  def process_command(command)
    destination = { x: x, y: y, direction: command }

    case command
    when "up"
      destination[:y] -= 1
    when "down"
      destination[:y] += 1
    when "left"
      destination[:x] -= 1
    when "right"
      destination[:x] += 1
    end

    destination
  end

  def process_command!(command)
    destination = process_command(command)
    if game.out_of_bounds?(destination[:x], destination[:y])
      update(direction: :neutral)
    else
      update(x: destination[:x], y: destination[:y], direction: command)
    end
  end

  def self.available_players
    %w[red blue green]
  end
end
