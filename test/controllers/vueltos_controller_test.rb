require 'test_helper'

class VueltosControllerTest < ActionController::TestCase
  setup do
    @vuelto = vueltos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vueltos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vuelto" do
    assert_difference('Vuelto.count') do
      post :create, vuelto: { code: @vuelto.code, date_processed: @vuelto.date_processed, fecha: @vuelto.fecha, processed: @vuelto.processed, total: @vuelto.total, user_id: @vuelto.user_id }
    end

    assert_redirected_to vuelto_path(assigns(:vuelto))
  end

  test "should show vuelto" do
    get :show, id: @vuelto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vuelto
    assert_response :success
  end

  test "should update vuelto" do
    patch :update, id: @vuelto, vuelto: { code: @vuelto.code, date_processed: @vuelto.date_processed, fecha: @vuelto.fecha, processed: @vuelto.processed, total: @vuelto.total, user_id: @vuelto.user_id }
    assert_redirected_to vuelto_path(assigns(:vuelto))
  end

  test "should destroy vuelto" do
    assert_difference('Vuelto.count', -1) do
      delete :destroy, id: @vuelto
    end

    assert_redirected_to vueltos_path
  end
end
