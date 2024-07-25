# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :product_name, null: false
      t.decimal :product_price, null: false, precision: 12, scale: 2, default: 0
      t.string :size, null: false
      t.integer :quantity, null: false
      t.virtual :total,
                type: :decimal,
                as: "product_price * quantity",
                stored: true,
                null: false,
                precision: 12,
                scale: 2
      t.string :customer_email, null: false
      t.string :customer_full_name, null: false
      t.string :customer_address, null: false
      t.boolean :fulfilled, null: false, default: false

      t.timestamps
    end

    add_index :orders, :fulfilled
  end
end
