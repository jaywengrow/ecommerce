class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :cart_count

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :stripe_customer_id])
  end

  def cart_count
    count = 0
    count += current_user.unpurchased_carted_products.inject(0) { |sum, carted_product| sum + carted_product.quantity } if current_user

    if current_user && count > 0 
      @cart_count = count
    else 
      @cart_count = 0
    end
  end

  def authenticate_admin!
    unless current_user && current_user.admin
      flash[:warning] = "You do not have access!"
      redirect_to "/"
    end
  end
end