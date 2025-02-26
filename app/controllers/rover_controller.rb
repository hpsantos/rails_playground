class RoverController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
    @game = Game.all
    @players = Player.all
  end
end
