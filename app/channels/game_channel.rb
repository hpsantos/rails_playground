class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel"
    Rails.logger.info("\n\n#################\n Client subscribed to game channel! \n#################\n\n")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
