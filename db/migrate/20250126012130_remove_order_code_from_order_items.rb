# frozen_string_literal: true

class RemoveOrderCodeFromOrderItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :order_items, :order_code, :string
  end
end
