require 'test_helper'

class LvtsControllerTest < ActionController::TestCase
  setup do
    @lvt = lvts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lvts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lvt" do
    assert_difference('Lvt.count') do
      post :create, lvt: { cdescuento: @lvt.cdescuento, cdevuelto: @lvt.cdevuelto, code: @lvt.code, comments: @lvt.comments, company_id: @lvt.company_id, compro_id: @lvt.compro_id, creembolso: @lvt.creembolso, descuento: @lvt.descuento, devuelto: @lvt.devuelto, devuelto_texto: @lvt.devuelto_texto, fecha: @lvt.fecha, gasto_id: @lvt.gasto_id, inicial: @lvt.inicial, lgv_id: @lvt.lgv_id, observa: @lvt.observa, peaje: @lvt.peaje, processed: @lvt.processed, reembolso: @lvt.reembolso, saldo: @lvt.saldo, total: @lvt.total, total_egreso: @lvt.total_egreso, total_ing: @lvt.total_ing, tranportorder_id: @lvt.tranportorder_id, tranportorder_id: @lvt.tranportorder_id, user_id: @lvt.user_id, viatico_id: @lvt.viatico_id }
    end

    assert_redirected_to lvt_path(assigns(:lvt))
  end

  test "should show lvt" do
    get :show, id: @lvt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lvt
    assert_response :success
  end

  test "should update lvt" do
    patch :update, id: @lvt, lvt: { cdescuento: @lvt.cdescuento, cdevuelto: @lvt.cdevuelto, code: @lvt.code, comments: @lvt.comments, company_id: @lvt.company_id, compro_id: @lvt.compro_id, creembolso: @lvt.creembolso, descuento: @lvt.descuento, devuelto: @lvt.devuelto, devuelto_texto: @lvt.devuelto_texto, fecha: @lvt.fecha, gasto_id: @lvt.gasto_id, inicial: @lvt.inicial, lgv_id: @lvt.lgv_id, observa: @lvt.observa, peaje: @lvt.peaje, processed: @lvt.processed, reembolso: @lvt.reembolso, saldo: @lvt.saldo, total: @lvt.total, total_egreso: @lvt.total_egreso, total_ing: @lvt.total_ing, tranportorder_id: @lvt.tranportorder_id, tranportorder_id: @lvt.tranportorder_id, user_id: @lvt.user_id, viatico_id: @lvt.viatico_id }
    assert_redirected_to lvt_path(assigns(:lvt))
  end

  test "should destroy lvt" do
    assert_difference('Lvt.count', -1) do
      delete :destroy, id: @lvt
    end

    assert_redirected_to lvts_path
  end
end
