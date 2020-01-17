require 'test_helper'

class EgresosControllerTest < ActionController::TestCase
  setup do
    @egreso = egresos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:egresos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create egreso" do
    assert_difference('Egreso.count') do
      post :create, egreso: { code: @egreso.code, name: @egreso.name }
    end

    assert_redirected_to egreso_path(assigns(:egreso))
  end

  test "should show egreso" do
    get :show, id: @egreso
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @egreso
    assert_response :success
  end

  test "should update egreso" do
    patch :update, id: @egreso, egreso: { code: @egreso.code, name: @egreso.name }
    assert_redirected_to egreso_path(assigns(:egreso))
  end

  test "should destroy egreso" do
    assert_difference('Egreso.count', -1) do
      delete :destroy, id: @egreso
    end

    assert_redirected_to egresos_path
  end
end
