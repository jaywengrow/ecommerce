json.extract! carted_product, :id, :product_id, :user_id, :order_id, :quantity, :purchased, :created_at, :updated_at
json.url carted_product_url(carted_product, format: :json)