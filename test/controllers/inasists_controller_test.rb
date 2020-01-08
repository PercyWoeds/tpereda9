require 'test_helper'

class InasistsControllerTest < ActionController::TestCase
  setup do
    @inasist = inasists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inasists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inasist" do
    assert_difference('Inasist.count') do
      post :create, inasist: { code: @inasist.code, name: @inasist.name }
    end

    assert_redirected_to inasist_path(assigns(:inasist))
  end

  test "should show inasist" do
    get :show, id: @inasist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inasist
    assert_response :success
  end

  test "should update inasist" do
    patch :update, id: @inasist, inasist: { code: @inasist.code, name: @inasist.name }
    assert_redirected_to inasist_path(assigns(:inasist))
  end

  test "should destroy inasist" do
    assert_difference('Inasist.count', -1) do
      delete :destroy, id: @inasist
    end

    assert_redirected_to inasists_path
  end
end
