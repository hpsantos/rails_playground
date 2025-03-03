class CreateBoosters < ActiveRecord::Migration[8.0]
  def change
    create_table :boosters do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.integer :value, null: false, default: 5
      t.integer :x, null: false
      t.integer :y, null: false

      t.timestamps
    end
  end
end
