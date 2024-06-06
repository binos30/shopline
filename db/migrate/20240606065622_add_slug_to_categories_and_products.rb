class AddSlugToCategoriesAndProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :slug, :string
    add_column :products, :slug, :string

    add_index :categories, :slug, unique: true
    add_index :products, :slug, unique: true

    Category.find_each(&:save)
    Product.find_each(&:save)

    change_column_null :categories, :slug, false
    change_column_null :products, :slug, false
  end
end
