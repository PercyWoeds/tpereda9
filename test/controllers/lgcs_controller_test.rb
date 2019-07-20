require 'test_helper'

class LgcsControllerTest < ActionController::TestCase
  setup do
    @lgc = lgcs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lgcs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lgc" do
    assert_difference('Lgc.count') do
      post :create, lgc: { abas_total: @lgc.abas_total, dscto_gln: @lgc.dscto_gln, employee_id: @lgc.employee_id, float: @lgc.float, idle_fuel: @lgc.idle_fuel, idletime: @lgc.idletime, km: @lgc.km, km_real: @lgc.km_real, margen: @lgc.margen, monto: @lgc.monto, monto_total: @lgc.monto_total, obser: @lgc.obser, peso_ida: @lgc.peso_ida, peso_ret: @lgc.peso_ret, placa_id2: @lgc.placa_id2, placa_id: @lgc.placa_id, ratio_fisico: @lgc.ratio_fisico, ratio_teorico: @lgc.ratio_teorico, recorrido: @lgc.recorrido, retorno_km: @lgc.retorno_km, rpm: @lgc.rpm, ruta: @lgc.ruta, salida_km: @lgc.salida_km, time_1: @lgc.time_1, tipo_carga_id: @lgc.tipo_carga_id, total_gal: @lgc.total_gal, user_id: @lgc.user_id, viaje_retorno_fecha: @lgc.viaje_retorno_fecha, viaje_salida_fecha: @lgc.viaje_salida_fecha }
    end

    assert_redirected_to lgc_path(assigns(:lgc))
  end

  test "should show lgc" do
    get :show, id: @lgc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lgc
    assert_response :success
  end

  test "should update lgc" do
    patch :update, id: @lgc, lgc: { abas_total: @lgc.abas_total, dscto_gln: @lgc.dscto_gln, employee_id: @lgc.employee_id, float: @lgc.float, idle_fuel: @lgc.idle_fuel, idletime: @lgc.idletime, km: @lgc.km, km_real: @lgc.km_real, margen: @lgc.margen, monto: @lgc.monto, monto_total: @lgc.monto_total, obser: @lgc.obser, peso_ida: @lgc.peso_ida, peso_ret: @lgc.peso_ret, placa_id2: @lgc.placa_id2, placa_id: @lgc.placa_id, ratio_fisico: @lgc.ratio_fisico, ratio_teorico: @lgc.ratio_teorico, recorrido: @lgc.recorrido, retorno_km: @lgc.retorno_km, rpm: @lgc.rpm, ruta: @lgc.ruta, salida_km: @lgc.salida_km, time_1: @lgc.time_1, tipo_carga_id: @lgc.tipo_carga_id, total_gal: @lgc.total_gal, user_id: @lgc.user_id, viaje_retorno_fecha: @lgc.viaje_retorno_fecha, viaje_salida_fecha: @lgc.viaje_salida_fecha }
    assert_redirected_to lgc_path(assigns(:lgc))
  end

  test "should destroy lgc" do
    assert_difference('Lgc.count', -1) do
      delete :destroy, id: @lgc
    end

    assert_redirected_to lgcs_path
  end
end
