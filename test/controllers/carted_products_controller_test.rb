require 'test_helper'

class CartedProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @carted_product = carted_products(:one)
  end

  test "should get index" do
    get carted_products_url
    assert_response :success
  end

  test "should get new" do
    get new_carted_product_url
    assert_response :success
  end

  test "should create carted_product" do
    assert_difference('CartedProduct.count') do
      post carted_products_url, params: { carted_product: { order_id: @carted_product.order_id, product_id: @carted_product.product_id, purchased: @carted_product.purchased, quantity: @carted_product.quantity, user_id: @carted_product.user_id } }
    end

    assert_redirected_to carted_product_url(CartedProduct.last)
  end

  test "should show carted_product" do
    get carted_product_url(@carted_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_carted_product_url(@carted_product)
    assert_response :success
  end

  test "should update carted_product" do
    patch carted_product_url(@carted_product), params: { carted_product: { order_id: @carted_product.order_id, product_id: @carted_product.product_id, purchased: @carted_product.purchased, quantity: @carted_product.quantity, user_id: @carted_product.user_id } }
    assert_redirected_to carted_product_url(@carted_product)
  end

  test "should destroy carted_product" do
    assert_difference('CartedProduct.count', -1) do
      delete carted_product_url(@carted_product)
    end

    assert_redirected_to carted_products_url
  end
end
