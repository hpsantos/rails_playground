class Game < ApplicationRecord
  has_many :players, dependent: :destroy

  def self.available_games
    %w[mars moon earth]
  end
end
