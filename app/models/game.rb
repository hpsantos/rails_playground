class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :boosters, dependent: :destroy

  def self.available_games
    %w[mars moon earth]
  end

  def out_of_bounds?(player_x, player_y)
    player_x.negative? || player_y.negative? || player_x >= cols - 1 || player_y >= rows - 1
  end
end
