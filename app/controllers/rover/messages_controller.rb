module Rover
  class MessagesController < ApplicationController
    # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
    allow_browser versions: :modern

    skip_before_action :verify_authenticity_token, only: [ :create ]

    def create
      Message.create(params[:message].permit(:player_id, :game_id, :body))

      render json: {}, status: :no_content
    end
  end
end
