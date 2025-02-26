class RoverGameStates < ActiveRecord::Migration[8.0]
  def change
    create_table :rover_game_states do |t|
      t.string :name
      t.integer :rows
      t.integer :cols
      t.integer :rover_x
      t.integer :rover_y
      t.integer :rover_direction
      t.timestamps
    end
  end
end
