require 'test_helper'

class TipocarguesControllerTest < ActionController::TestCase
  setup do
    @tipocargue = tipocargues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipocargues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipocargue" do
    assert_difference('Tipocargue.count') do
      post :create, tipocargue: { code: @tipocargue.code, name: @tipocargue.name }
    end

    assert_redirected_to tipocargue_path(assigns(:tipocargue))
  end

  test "should show tipocargue" do
    get :show, id: @tipocargue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipocargue
    assert_response :success
  end

  test "should update tipocargue" do
    patch :update, id: @tipocargue, tipocargue: { code: @tipocargue.code, name: @tipocargue.name }
    assert_redirected_to tipocargue_path(assigns(:tipocargue))
  end

  test "should destroy tipocargue" do
    assert_difference('Tipocargue.count', -1) do
      delete :destroy, id: @tipocargue
    end

    assert_redirected_to tipocargues_path
  end
end
