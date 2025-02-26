class RoverController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
    @state = RoverGameState.first
    return if @state

    @state = RoverGameState.create(name: "default", rows: 20, cols: 20, rover_x: 10, rover_y: 10, rover_direction: 0)
  end
end
