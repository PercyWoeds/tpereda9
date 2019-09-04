require 'test_helper'

class EessesControllerTest < ActionController::TestCase
  setup do
    @eess = eesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eess" do
    assert_difference('Eess.count') do
      post :create, eess: { address: @eess.address, code: @eess.code, nombre: @eess.nombre }
    end

    assert_redirected_to eess_path(assigns(:eess))
  end

  test "should show eess" do
    get :show, id: @eess
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eess
    assert_response :success
  end

  test "should update eess" do
    patch :update, id: @eess, eess: { address: @eess.address, code: @eess.code, nombre: @eess.nombre }
    assert_redirected_to eess_path(assigns(:eess))
  end

  test "should destroy eess" do
    assert_difference('Eess.count', -1) do
      delete :destroy, id: @eess
    end

    assert_redirected_to eesses_path
  end
end
