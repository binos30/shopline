json.extract! product,
              :id,
              :name,
              :description,
              :price,
              :active,
              :category_id,
              :created_at,
              :updated_at
json.url admin_product_url(product, format: :json)
