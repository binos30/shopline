json.extract! order,
              :id,
              :product_id,
              :user_id,
              :product_name,
              :product_price,
              :size,
              :quantity,
              :total,
              :customer_email,
              :customer_full_name,
              :customer_address,
              :fulfilled,
              :created_at,
              :updated_at
json.url admin_order_url(order, format: :json)
