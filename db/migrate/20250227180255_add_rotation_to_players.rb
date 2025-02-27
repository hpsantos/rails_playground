class AddRotationToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :rotation, :integer, default: 0
  end
end
