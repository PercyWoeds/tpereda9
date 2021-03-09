require 'test_helper'

class TramitsControllerTest < ActionController::TestCase
  setup do
    @tramit = tramits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tramits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tramit" do
    assert_difference('Tramit.count') do
      post :create, tramit: { code: @tramit.code, name: @tramit.name }
    end

    assert_redirected_to tramit_path(assigns(:tramit))
  end

  test "should show tramit" do
    get :show, id: @tramit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tramit
    assert_response :success
  end

  test "should update tramit" do
    patch :update, id: @tramit, tramit: { code: @tramit.code, name: @tramit.name }
    assert_redirected_to tramit_path(assigns(:tramit))
  end

  test "should destroy tramit" do
    assert_difference('Tramit.count', -1) do
      delete :destroy, id: @tramit
    end

    assert_redirected_to tramits_path
  end
end
