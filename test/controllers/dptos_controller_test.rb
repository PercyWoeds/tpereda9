require 'test_helper'

class DptosControllerTest < ActionController::TestCase
  setup do
    @dpto = dptos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dptos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dpto" do
    assert_difference('Dpto.count') do
      post :create, dpto: { code: @dpto.code, name: @dpto.name, ubigeo: @dpto.ubigeo }
    end

    assert_redirected_to dpto_path(assigns(:dpto))
  end

  test "should show dpto" do
    get :show, id: @dpto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dpto
    assert_response :success
  end

  test "should update dpto" do
    patch :update, id: @dpto, dpto: { code: @dpto.code, name: @dpto.name, ubigeo: @dpto.ubigeo }
    assert_redirected_to dpto_path(assigns(:dpto))
  end

  test "should destroy dpto" do
    assert_difference('Dpto.count', -1) do
      delete :destroy, id: @dpto
    end

    assert_redirected_to dptos_path
  end
end
