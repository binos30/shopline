json.extract! category,
              :id,
              :name,
              :description,
              :active,
              :created_at,
              :updated_at
json.url admin_category_url(category, format: :json)
