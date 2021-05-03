require 'test_helper'

class ViaticolgvDetailsControllerTest < ActionController::TestCase
  setup do
    @viaticolgv_detail = viaticolgv_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:viaticolgv_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create viaticolgv_detail" do
    assert_difference('ViaticolgvDetail.count') do
      post :create, viaticolgv_detail: { CurrTotal: @viaticolgv_detail.CurrTotal, date_processed: @viaticolgv_detail.date_processed, descrip: @viaticolgv_detail.descrip, destino_id: @viaticolgv_detail.destino_id, detalle: @viaticolgv_detail.detalle, document_id: @viaticolgv_detail.document_id, egreso_id: @viaticolgv_detail.egreso_id, employee_id: @viaticolgv_detail.employee_id, fecha: @viaticolgv_detail.fecha, gasto_id: @viaticolgv_detail.gasto_id, importe: @viaticolgv_detail.importe, numero: @viaticolgv_detail.numero, ruc: @viaticolgv_detail.ruc, supplier_id: @viaticolgv_detail.supplier_id, tm: @viaticolgv_detail.tm, tranportorder_id: @viaticolgv_detail.tranportorder_id, viatico_id: @viaticolgv_detail.viatico_id, viaticolgv_id: @viaticolgv_detail.viaticolgv_id }
    end

    assert_redirected_to viaticolgv_detail_path(assigns(:viaticolgv_detail))
  end

  test "should show viaticolgv_detail" do
    get :show, id: @viaticolgv_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @viaticolgv_detail
    assert_response :success
  end

  test "should update viaticolgv_detail" do
    patch :update, id: @viaticolgv_detail, viaticolgv_detail: { CurrTotal: @viaticolgv_detail.CurrTotal, date_processed: @viaticolgv_detail.date_processed, descrip: @viaticolgv_detail.descrip, destino_id: @viaticolgv_detail.destino_id, detalle: @viaticolgv_detail.detalle, document_id: @viaticolgv_detail.document_id, egreso_id: @viaticolgv_detail.egreso_id, employee_id: @viaticolgv_detail.employee_id, fecha: @viaticolgv_detail.fecha, gasto_id: @viaticolgv_detail.gasto_id, importe: @viaticolgv_detail.importe, numero: @viaticolgv_detail.numero, ruc: @viaticolgv_detail.ruc, supplier_id: @viaticolgv_detail.supplier_id, tm: @viaticolgv_detail.tm, tranportorder_id: @viaticolgv_detail.tranportorder_id, viatico_id: @viaticolgv_detail.viatico_id, viaticolgv_id: @viaticolgv_detail.viaticolgv_id }
    assert_redirected_to viaticolgv_detail_path(assigns(:viaticolgv_detail))
  end

  test "should destroy viaticolgv_detail" do
    assert_difference('ViaticolgvDetail.count', -1) do
      delete :destroy, id: @viaticolgv_detail
    end

    assert_redirected_to viaticolgv_details_path
  end
end
