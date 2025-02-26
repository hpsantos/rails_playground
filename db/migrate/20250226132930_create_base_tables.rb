class CreateBaseTables < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.integer :rows, null: false, default: 10
      t.integer :cols, null: false, default: 10

      t.timestamps
    end

    create_table :players do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.integer :direction, null: false, default: 1

      t.timestamps
    end
  end
end
