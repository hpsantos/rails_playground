module Rover
  class GameController < ApplicationController
    # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
    allow_browser versions: :modern

    skip_before_action :verify_authenticity_token, only: [ :update ]

    def index
      @game = Game.find_by(name: params[:game])
      @player = Player.find_or_create_by(name: params[:player], game: @game)

      Rails.logger.info("######### IM HERE #########")
      Rails.logger.info("Game: #{@game}")
      Rails.logger.info("Player: #{@player}")

      redirect_back if !@game || !@player
    end

    def update
      @player = Player.find(params[:player])
      @player.process_command!(params[:command])

      @game = @player.game

      render json: {
        game: @player.game,
        players: @game.players
      }
    end
  end
end
