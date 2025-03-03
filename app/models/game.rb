class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :boosters, dependent: :destroy

  def regenerate_boosters
    boosters.delete_all
    2.times do
      boosters.build(x: rand(0..cols - 2), y: rand(0..rows - 2), value: Booster.available_values.sample)
    end
    save
  end

  def out_of_bounds?(player_x, player_y)
    player_x.negative? || player_y.negative? || player_x >= cols - 1 || player_y >= rows - 1
  end

  def self.available_games
    %w[mars moon earth]
  end
end
