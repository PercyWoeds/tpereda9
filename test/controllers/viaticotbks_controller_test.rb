require 'test_helper'

class ViaticotbksControllerTest < ActionController::TestCase
  setup do
    @viaticotbk = viaticotbks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:viaticotbks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create viaticotbk" do
    assert_difference('Viaticotbk.count') do
      post :create, viaticotbk: { caja_id: @viaticotbk.caja_id, cdescuento: @viaticotbk.cdescuento, cdevuelto: @viaticotbk.cdevuelto, code: @viaticotbk.code, comments: @viaticotbk.comments, company_id: @viaticotbk.company_id, compro_id: @viaticotbk.compro_id, creembolso: @viaticotbk.creembolso, date_processed: @viaticotbk.date_processed, fecha1: @viaticotbk.fecha1, inicial: @viaticotbk.inicial, processed: @viaticotbk.processed, saldo: @viaticotbk.saldo, tipo: @viaticotbk.tipo, total_egreso: @viaticotbk.total_egreso, total_ing: @viaticotbk.total_ing, user_id: @viaticotbk.user_id }
    end

    assert_redirected_to viaticotbk_path(assigns(:viaticotbk))
  end

  test "should show viaticotbk" do
    get :show, id: @viaticotbk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @viaticotbk
    assert_response :success
  end

  test "should update viaticotbk" do
    patch :update, id: @viaticotbk, viaticotbk: { caja_id: @viaticotbk.caja_id, cdescuento: @viaticotbk.cdescuento, cdevuelto: @viaticotbk.cdevuelto, code: @viaticotbk.code, comments: @viaticotbk.comments, company_id: @viaticotbk.company_id, compro_id: @viaticotbk.compro_id, creembolso: @viaticotbk.creembolso, date_processed: @viaticotbk.date_processed, fecha1: @viaticotbk.fecha1, inicial: @viaticotbk.inicial, processed: @viaticotbk.processed, saldo: @viaticotbk.saldo, tipo: @viaticotbk.tipo, total_egreso: @viaticotbk.total_egreso, total_ing: @viaticotbk.total_ing, user_id: @viaticotbk.user_id }
    assert_redirected_to viaticotbk_path(assigns(:viaticotbk))
  end

  test "should destroy viaticotbk" do
    assert_difference('Viaticotbk.count', -1) do
      delete :destroy, id: @viaticotbk
    end

    assert_redirected_to viaticotbks_path
  end
end
