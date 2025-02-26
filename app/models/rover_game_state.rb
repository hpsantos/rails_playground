class RoverGameState < ApplicationRecord
  def process_command(command)
    case command
    when "up"
      self.rover_y -= 1
    when "down"
      self.rover_y += 1
    when "left"
      self.rover_x -= 1
    when "right"
      self.rover_x += 1
    end
  end
end
