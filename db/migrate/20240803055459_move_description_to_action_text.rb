# frozen_string_literal: true

class MoveDescriptionToActionText < ActiveRecord::Migration[7.1]
  def change
    # Rename first the column to avoid error when migrating
    rename_column :categories, :description, :description1
    rename_column :products, :description, :description1

    Category.find_each { |category| category.update!(description: category.description1) }
    Product.find_each { |product| product.update!(description: product.description1) }

    remove_column :categories, :description1
    remove_column :products, :description1
  end
end
