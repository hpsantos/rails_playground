class Player < ApplicationRecord
  belongs_to :game

  validates :name, presence: true, uniqueness: true
  validates :game_id, uniqueness: { scope: %i[name] }
  validates :x, presence: true
  validates :y, presence: true
  validates :rotation, presence: true
  after_save :broadcast_update

  enum :direction, { up: 0, right: 1, down: 2, left: 3 }

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

  def calculate_rotation(previous_direction, direction, rotation) # rubocop:disable Metrics/CyclomaticComplexity
    if previous_direction == direction
      rotation
    else
      case [ previous_direction, direction ]
      when %w[up right]
        rotation + 90
      when %w[up left]
        rotation - 90
      when %w[up down]
        rotation + 180
      when %w[right up]
        rotation - 90
      when %w[right left]
        rotation + 180
      when %w[right down]
        rotation + 90
      when %w[down up]
        rotation + 180
      when %w[down right]
        rotation - 90
      when %w[down left]
        rotation + 90
      when %w[left up]
        rotation + 90
      when %w[left right]
        rotation + 180
      when %w[left down]
        rotation - 90
      end
    end
  end

  def process_command!(command)
    destination = process_command(command)
    return if game.out_of_bounds?(destination[:x], destination[:y])

    new_rotation = calculate_rotation(direction, command, rotation)

    update(
      x: destination[:x],
      y: destination[:y],
      direction: command,
      rotation: new_rotation
    )
  end

  def self.available_players
    %w[red blue green]
  end
end
