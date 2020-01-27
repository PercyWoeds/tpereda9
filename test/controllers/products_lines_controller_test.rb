require 'test_helper'

class ProductsLinesControllerTest < ActionController::TestCase
  setup do
    @products_line = products_lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create products_line" do
    assert_difference('ProductsLine.count') do
      post :create, products_line: { code: @products_line.code, name: @products_line.name, user_id: @products_line.user_id }
    end

    assert_redirected_to products_line_path(assigns(:products_line))
  end

  test "should show products_line" do
    get :show, id: @products_line
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @products_line
    assert_response :success
  end

  test "should update products_line" do
    patch :update, id: @products_line, products_line: { code: @products_line.code, name: @products_line.name, user_id: @products_line.user_id }
    assert_redirected_to products_line_path(assigns(:products_line))
  end

  test "should destroy products_line" do
    assert_difference('ProductsLine.count', -1) do
      delete :destroy, id: @products_line
    end

    assert_redirected_to products_lines_path
  end
end
