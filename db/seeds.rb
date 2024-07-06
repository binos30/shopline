# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

100.times.with_index do |i|
  Category.create(
    name: "Category #{i + 1}",
    description: "Category #{i + 1} description"
  )
  puts "Created category #{i + 1}"
end

category_ids = Category.pluck(:id)
prices = [30, 60, 90]
sizes = %w[S M L].freeze
100.times.with_index do |i|
  product =
    Product.create(
      category_id: category_ids.sample,
      name: "Product #{i + 1}",
      description: "Product #{i + 1} description",
      price: prices.sample
    )
  product.stocks.create(size: sizes.sample, quantity: 3)
  puts "Created product #{i + 1}"
end
