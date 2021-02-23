require 'test_helper'

class Proyectominero3sControllerTest < ActionController::TestCase
  setup do
    @proyectominero3 = proyectominero3s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyectominero3s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyectominero3" do
    assert_difference('Proyectominero3.count') do
      post :create, proyectominero3: { code: @proyectominero3.code, name: @proyectominero3.name, user_id: @proyectominero3.user_id }
    end

    assert_redirected_to proyectominero3_path(assigns(:proyectominero3))
  end

  test "should show proyectominero3" do
    get :show, id: @proyectominero3
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proyectominero3
    assert_response :success
  end

  test "should update proyectominero3" do
    patch :update, id: @proyectominero3, proyectominero3: { code: @proyectominero3.code, name: @proyectominero3.name, user_id: @proyectominero3.user_id }
    assert_redirected_to proyectominero3_path(assigns(:proyectominero3))
  end

  test "should destroy proyectominero3" do
    assert_difference('Proyectominero3.count', -1) do
      delete :destroy, id: @proyectominero3
    end

    assert_redirected_to proyectominero3s_path
  end
end
