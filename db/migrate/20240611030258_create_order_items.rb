# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.string :order_code, null: false, index: true
      t.string :product_name, null: false
      t.decimal :product_price, null: false, precision: 12, scale: 2, default: 0
      t.string :size, null: false
      t.integer :quantity, null: false
      t.virtual :subtotal,
                type: :decimal,
                as: "product_price * quantity",
                stored: true,
                null: false,
                precision: 12,
                scale: 2

      t.timestamps
    end

    remove_column :orders, :total, :decimal
    remove_column :orders, :product_id, :bigint
    remove_column :orders, :product_name, :string
    remove_column :orders, :product_price, :decimal
    remove_column :orders, :size, :string
    remove_column :orders, :quantity, :integer

    add_index :orders, :customer_email
    add_column :orders, :order_code, :string, null: false
    add_index :orders, :order_code, unique: true
    add_column :orders, :total, :decimal, null: false, precision: 12, scale: 2, default: 0
  end
end
