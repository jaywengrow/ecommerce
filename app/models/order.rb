class Order < ApplicationRecord

  belongs_to :user
  has_many :carted_products
  has_many :products, through: :carted_products

  def update_carted_status
    user.unpurchased_carted_products.each {|carted_product| carted_product.update(purchased: true, order_id: id)}
  end

  def order_date
    created_at.strftime("%b %e, %Y %l:%M %p")
  end
end
