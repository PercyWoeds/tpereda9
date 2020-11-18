require 'test_helper'

class CoutsControllerTest < ActionController::TestCase
  setup do
    @cout = couts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:couts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cout" do
    assert_difference('Cout.count') do
      post :create, cout: { alimento: @cout.alimento, code: @cout.code, descuento: @cout.descuento, employee2_id: @cout.employee2_id, employee3_id: @cout.employee3_id, employee_id: @cout.employee_id, fecha: @cout.fecha, flete: @cout.flete, flete: @cout.flete, importe: @cout.importe, lavado: @cout.lavado, llanta: @cout.llanta, monto_recibido: @cout.monto_recibido, ost_id: @cout.ost_id, otros: @cout.otros, peajes: @cout.peajes, punto_id: @cout.punto_id, recibido_ruta: @cout.recibido_ruta, reembolso: @cout.reembolso, tranportorder_id: @cout.tranportorder_id, truck_id: @cout.truck_id, vuelto: @cout.vuelto }
    end

    assert_redirected_to cout_path(assigns(:cout))
  end

  test "should show cout" do
    get :show, id: @cout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cout
    assert_response :success
  end

  test "should update cout" do
    patch :update, id: @cout, cout: { alimento: @cout.alimento, code: @cout.code, descuento: @cout.descuento, employee2_id: @cout.employee2_id, employee3_id: @cout.employee3_id, employee_id: @cout.employee_id, fecha: @cout.fecha, flete: @cout.flete, flete: @cout.flete, importe: @cout.importe, lavado: @cout.lavado, llanta: @cout.llanta, monto_recibido: @cout.monto_recibido, ost_id: @cout.ost_id, otros: @cout.otros, peajes: @cout.peajes, punto_id: @cout.punto_id, recibido_ruta: @cout.recibido_ruta, reembolso: @cout.reembolso, tranportorder_id: @cout.tranportorder_id, truck_id: @cout.truck_id, vuelto: @cout.vuelto }
    assert_redirected_to cout_path(assigns(:cout))
  end

  test "should destroy cout" do
    assert_difference('Cout.count', -1) do
      delete :destroy, id: @cout
    end

    assert_redirected_to couts_path
  end
end
