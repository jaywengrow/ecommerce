class Product < ApplicationRecord
  mount_uploaders :images, ImageUploader

  has_many :carted_products
end
