# frozen_string_literal: true

class IndexOrdersOnCustomerFullName < ActiveRecord::Migration[7.1]
  def change
    add_index :orders, :customer_full_name
  end
end
