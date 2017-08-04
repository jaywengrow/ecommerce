class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :edit, :update, :destroy, :thank_you]
  before_action :set_order, only: [:show, :edit, :update, :destroy, :thank_you]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    if current_user.admin || current_user.id == @order.user_id
      @carted_products = @order.carted_products
    else 
      flash[:warning] = "You do not have access!"
      redirect_to "/"
    end
  end

  def thank_you
    if current_user.admin || current_user.id == @order.user_id
      @carted_products = @order.carted_products
    else 
      flash[:warning] = "You do not have access!"
      redirect_to "/"
    end
  end

  # GET /orders/new
  def new
    if @cart_count > 0
      @order = Order.new
    else
      flash[:warning] = "Your cart is empty!"
      redirect_to "/"
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(user_id: params[:user_id], subtotal: params[:subtotal], tax: params[:tax], total: params[:total])
    token = params[:stripeToken]
    if current_user.stripe_customer_id.present?
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    else
      customer = Stripe::Customer.create(email: current_user.email, :source => token)
      current_user.update(stripe_customer_id: customer.id)
    end

    # Create a charge: this will charge the user's card
    begin

      charge = Stripe::Charge.create(
        :amount => (@order.total * 100).to_i, # Amount in cents
        :currency => "usd",
        :customer => customer.id
      )

      if @order.save
        @order.update(order_number: "#{ SecureRandom.hex(3).upcase }-#{ @order.id }")
        @order.update_carted_status
        redirect_to order_thank_you_path(@order), notice: 'Thank you for your order!'
      else
        render :new
      end

    rescue Stripe::CardError => e
      render :new, notice: "Error: #{ e.message }"
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id, :subtotal, :tax, :total, :order_number)
    end
end


