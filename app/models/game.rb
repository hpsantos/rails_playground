class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  def self.available_games
    %w[mars moon earth]
  end

  def out_of_bounds?(player_x, player_y)
    player_x.negative? || player_y.negative? || player_x >= cols || player_y >= rows
  end
end
