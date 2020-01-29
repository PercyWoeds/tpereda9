require 'test_helper'

class TelecreditoDetailsControllerTest < ActionController::TestCase
  setup do
    @telecredito_detail = telecredito_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:telecredito_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create telecredito_detail" do
    assert_difference('TelecreditoDetail.count') do
      post :create, telecredito_detail: { aprueba: @telecredito_detail.aprueba, beneficiario: @telecredito_detail.beneficiario, documento: @telecredito_detail.documento, egreso: @telecredito_detail.egreso, fecha: @telecredito_detail.fecha, importe: @telecredito_detail.importe, moneda: @telecredito_detail.moneda, nro: @telecredito_detail.nro, observacion: @telecredito_detail.observacion, operacion: @telecredito_detail.operacion, purchase_id: @telecredito_detail.purchase_id, telecredito_id: @telecredito_detail.telecredito_id }
    end

    assert_redirected_to telecredito_detail_path(assigns(:telecredito_detail))
  end

  test "should show telecredito_detail" do
    get :show, id: @telecredito_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @telecredito_detail
    assert_response :success
  end

  test "should update telecredito_detail" do
    patch :update, id: @telecredito_detail, telecredito_detail: { aprueba: @telecredito_detail.aprueba, beneficiario: @telecredito_detail.beneficiario, documento: @telecredito_detail.documento, egreso: @telecredito_detail.egreso, fecha: @telecredito_detail.fecha, importe: @telecredito_detail.importe, moneda: @telecredito_detail.moneda, nro: @telecredito_detail.nro, observacion: @telecredito_detail.observacion, operacion: @telecredito_detail.operacion, purchase_id: @telecredito_detail.purchase_id, telecredito_id: @telecredito_detail.telecredito_id }
    assert_redirected_to telecredito_detail_path(assigns(:telecredito_detail))
  end

  test "should destroy telecredito_detail" do
    assert_difference('TelecreditoDetail.count', -1) do
      delete :destroy, id: @telecredito_detail
    end

    assert_redirected_to telecredito_details_path
  end
end
