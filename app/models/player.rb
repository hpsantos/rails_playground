class Player < ApplicationRecord
  belongs_to :game

  validates :name, presence: true, uniqueness: true
  validates :game_id, uniqueness: { scope: %i[name] }
  validates :x, presence: true
  validates :y, presence: true

  def self.available_players
    %w[red blue green]
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
end
