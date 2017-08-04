json.extract! order, :id, :user_id, :subtotal, :tax, :total, :order_number, :created_at, :updated_at

json.carted_products order.carted_products.each do |carted_product|
  json.id carted_product.id
  json.order_id carted_product.order_id
  json.user_id carted_product.user_id
  json.product_id carted_product.product_id
  json.quantity carted_product.quantity
  json.product carted_product.product
end

json.url order_url(order, format: :json)