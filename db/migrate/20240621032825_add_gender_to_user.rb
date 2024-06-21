class AddGenderToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :gender, :string
    add_index :users, :gender

    User.find_each { |user| user.update!(gender: "male") }

    change_column_null :users, :gender, false
  end
end
