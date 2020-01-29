require 'test_helper'

class TelecreditosControllerTest < ActionController::TestCase
  setup do
    @telecredito = telecreditos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:telecreditos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create telecredito" do
    assert_difference('Telecredito.count') do
      post :create, telecredito: { bank_acount_id: @telecredito.bank_acount_id, code: @telecredito.code, fecha1: @telecredito.fecha1, fecha2: @telecredito.fecha2, importe: @telecredito.importe }
    end

    assert_redirected_to telecredito_path(assigns(:telecredito))
  end

  test "should show telecredito" do
    get :show, id: @telecredito
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @telecredito
    assert_response :success
  end

  test "should update telecredito" do
    patch :update, id: @telecredito, telecredito: { bank_acount_id: @telecredito.bank_acount_id, code: @telecredito.code, fecha1: @telecredito.fecha1, fecha2: @telecredito.fecha2, importe: @telecredito.importe }
    assert_redirected_to telecredito_path(assigns(:telecredito))
  end

  test "should destroy telecredito" do
    assert_difference('Telecredito.count', -1) do
      delete :destroy, id: @telecredito
    end

    assert_redirected_to telecreditos_path
  end
end
