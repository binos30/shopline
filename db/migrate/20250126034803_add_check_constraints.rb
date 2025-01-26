# frozen_string_literal: true

class AddCheckConstraints < ActiveRecord::Migration[7.2]
  def change
    add_check_constraint :order_items, "product_price >= 0", name: "product_price_non_negative"
    add_check_constraint :order_items, "quantity > 0", name: "quantity_positive"
    add_check_constraint :products, "price >= 0", name: "price_non_negative"
    add_check_constraint :stocks, "quantity >= 0", name: "quantity_non_negative"
  end
end
