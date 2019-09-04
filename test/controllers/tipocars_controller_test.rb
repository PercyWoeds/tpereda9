require 'test_helper'

class TipocarsControllerTest < ActionController::TestCase
  setup do
    @tipocar = tipocars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipocars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipocar" do
    assert_difference('Tipocar.count') do
      post :create, tipocar: { code: @tipocar.code, nombre: @tipocar.nombre }
    end

    assert_redirected_to tipocar_path(assigns(:tipocar))
  end

  test "should show tipocar" do
    get :show, id: @tipocar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipocar
    assert_response :success
  end

  test "should update tipocar" do
    patch :update, id: @tipocar, tipocar: { code: @tipocar.code, nombre: @tipocar.nombre }
    assert_redirected_to tipocar_path(assigns(:tipocar))
  end

  test "should destroy tipocar" do
    assert_difference('Tipocar.count', -1) do
      delete :destroy, id: @tipocar
    end

    assert_redirected_to tipocars_path
  end
end
