json.extract! product, :id, :name, :sku, :price, :description, :color, :size, :dimensions, :created_at, :updated_at
json.url product_url(product, format: :json)