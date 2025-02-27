class AddUniquePlayerIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :players, %i[game_id name], unique: true
    add_index :players, :name, unique: true
  end
end
