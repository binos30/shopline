class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size, null: false
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end

    add_index :stocks, %i[product_id size], unique: true
  end
end
