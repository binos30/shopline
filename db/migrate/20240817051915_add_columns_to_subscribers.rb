# frozen_string_literal: true

class AddColumnsToSubscribers < ActiveRecord::Migration[7.2]
  def change
    add_column :subscribers, :ip_address, :string, null: false, default: ""
    add_column :subscribers, :user_agent, :string, null: false, default: ""
  end
end
