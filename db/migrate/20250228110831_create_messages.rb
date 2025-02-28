class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.belongs_to :player
      t.belongs_to :game
      t.text :body

      t.timestamps
    end
  end
end
