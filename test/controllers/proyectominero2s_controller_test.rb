require 'test_helper'

class Proyectominero2sControllerTest < ActionController::TestCase
  setup do
    @proyectominero2 = proyectominero2s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyectominero2s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyectominero2" do
    assert_difference('Proyectominero2.count') do
      post :create, proyectominero2: { code: @proyectominero2.code, name: @proyectominero2.name, user_id: @proyectominero2.user_id }
    end

    assert_redirected_to proyectominero2_path(assigns(:proyectominero2))
  end

  test "should show proyectominero2" do
    get :show, id: @proyectominero2
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proyectominero2
    assert_response :success
  end

  test "should update proyectominero2" do
    patch :update, id: @proyectominero2, proyectominero2: { code: @proyectominero2.code, name: @proyectominero2.name, user_id: @proyectominero2.user_id }
    assert_redirected_to proyectominero2_path(assigns(:proyectominero2))
  end

  test "should destroy proyectominero2" do
    assert_difference('Proyectominero2.count', -1) do
      delete :destroy, id: @proyectominero2
    end

    assert_redirected_to proyectominero2s_path
  end
end
