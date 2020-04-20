require 'test_helper'

class TipoproveedorsControllerTest < ActionController::TestCase
  setup do
    @tipoproveedor = tipoproveedors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipoproveedors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipoproveedor" do
    assert_difference('Tipoproveedor.count') do
      post :create, tipoproveedor: { code: @tipoproveedor.code, name: @tipoproveedor.name }
    end

    assert_redirected_to tipoproveedor_path(assigns(:tipoproveedor))
  end

  test "should show tipoproveedor" do
    get :show, id: @tipoproveedor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipoproveedor
    assert_response :success
  end

  test "should update tipoproveedor" do
    patch :update, id: @tipoproveedor, tipoproveedor: { code: @tipoproveedor.code, name: @tipoproveedor.name }
    assert_redirected_to tipoproveedor_path(assigns(:tipoproveedor))
  end

  test "should destroy tipoproveedor" do
    assert_difference('Tipoproveedor.count', -1) do
      delete :destroy, id: @tipoproveedor
    end

    assert_redirected_to tipoproveedors_path
  end
end
