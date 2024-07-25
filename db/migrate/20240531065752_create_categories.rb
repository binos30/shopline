# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :categories, :name, unique: true
    add_index :categories, :active
  end
end
