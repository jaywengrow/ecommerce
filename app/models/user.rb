class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :carted_products
  has_many :orders
  has_many :products, through: :carted_products

  def order_total
    (subtotal + tax).to_f.round(2)
  end

  def subtotal
    sub_total = 0
    sub_total += unpurchased_carted_products.inject(0) { |sum, carted_product| sum + carted_product.product.price * carted_product.quantity }
  end

  def tax
    subtotal * 0.09
  end

  def unpurchased_carted_products
    carted_products.where(purchased: false)
  end

end
