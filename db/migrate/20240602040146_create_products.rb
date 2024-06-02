class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, null: false, precision: 12, scale: 2, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :products, :name, unique: true
    add_index :products, :active
  end
end
