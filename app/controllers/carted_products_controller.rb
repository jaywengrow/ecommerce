class CartedProductsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_carted_product, only: [:show, :edit, :update, :destroy]

  # GET /carted_products
  # GET /carted_products.json
  def index
    @carted_products = current_user.carted_products.where(purchased: false)
  end

  # GET /carted_products/1
  # GET /carted_products/1.json
  def show
  end

  # GET /carted_products/new
  def new
    @carted_product = CartedProduct.new
  end

  # GET /carted_products/1/edit
  def edit
  end

  # POST /carted_products
  # POST /carted_products.json
  def create
    @carted_product = CartedProduct.new(carted_product_params)

    respond_to do |format|
      if @carted_product.save
        format.html { redirect_to product_path(@carted_product.product_id), notice: 'Item added to cart.' }
        format.json { render :show, status: :created, location: @carted_product }
      else
        format.html { render :new }
        format.json { render json: @carted_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carted_products/1
  # PATCH/PUT /carted_products/1.json
  def update
    respond_to do |format|
      if @carted_product.update(carted_product_params)
        format.html { redirect_to @carted_product, notice: 'Carted product was successfully updated.' }
        format.json { render :show, status: :ok, location: @carted_product }
      else
        format.html { render :edit }
        format.json { render json: @carted_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carted_products/1
  # DELETE /carted_products/1.json
  def destroy
    @carted_product.destroy
    respond_to do |format|
      format.html { redirect_to carted_products_url, notice: 'Carted product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carted_product
      @carted_product = CartedProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carted_product_params
      params.require(:carted_product).permit(:product_id, :user_id, :order_id, :quantity, :purchased)
    end
end
