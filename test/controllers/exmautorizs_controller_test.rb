require 'test_helper'

class ExmautorizsControllerTest < ActionController::TestCase
  setup do
    @exmautoriz = exmautorizs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exmautorizs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exmautoriz" do
    assert_difference('Exmautoriz.count') do
      post :create, exmautoriz: { antecedent_id: @exmautoriz.antecedent_id, curso_cap: @exmautoriz.curso_cap, employee2_id: @exmautoriz.employee2_id, employee3_id: @exmautoriz.employee3_id, employee4_id: @exmautoriz.employee4_id, employee5_id: @exmautoriz.employee5_id, employee_id: @exmautoriz.employee_id, fecha_carga_rt: @exmautoriz.fecha_carga_rt, fecha_ingreso: @exmautoriz.fecha_ingreso, fecha_vmto: @exmautoriz.fecha_vmto, fecha_vmto_ant: @exmautoriz.fecha_vmto_ant, fecha_vmto_cap: @exmautoriz.fecha_vmto_cap, fecha_vmto_ot: @exmautoriz.fecha_vmto_ot, fecha_vmto_rt: @exmautoriz.fecha_vmto_rt, obs_ant: @exmautoriz.obs_ant, obs_cap: @exmautoriz.obs_cap, obs_ot: @exmautoriz.obs_ot, obs_rt: @exmautoriz.obs_rt, proyecto_minero_id: @exmautoriz.proyecto_minero_id, proyecto_minero_id: @exmautoriz.proyecto_minero_id, supplier_id: @exmautoriz.supplier_id, tipo_antecedent_id: @exmautoriz.tipo_antecedent_id, tipo_revision_tecnica: @exmautoriz.tipo_revision_tecnica, tipo_tramit_id: @exmautoriz.tipo_tramit_id, tramit_id: @exmautoriz.tramit_id, tramite: @exmautoriz.tramite, truck_id: @exmautoriz.truck_id }
    end

    assert_redirected_to exmautoriz_path(assigns(:exmautoriz))
  end

  test "should show exmautoriz" do
    get :show, id: @exmautoriz
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exmautoriz
    assert_response :success
  end

  test "should update exmautoriz" do
    patch :update, id: @exmautoriz, exmautoriz: { antecedent_id: @exmautoriz.antecedent_id, curso_cap: @exmautoriz.curso_cap, employee2_id: @exmautoriz.employee2_id, employee3_id: @exmautoriz.employee3_id, employee4_id: @exmautoriz.employee4_id, employee5_id: @exmautoriz.employee5_id, employee_id: @exmautoriz.employee_id, fecha_carga_rt: @exmautoriz.fecha_carga_rt, fecha_ingreso: @exmautoriz.fecha_ingreso, fecha_vmto: @exmautoriz.fecha_vmto, fecha_vmto_ant: @exmautoriz.fecha_vmto_ant, fecha_vmto_cap: @exmautoriz.fecha_vmto_cap, fecha_vmto_ot: @exmautoriz.fecha_vmto_ot, fecha_vmto_rt: @exmautoriz.fecha_vmto_rt, obs_ant: @exmautoriz.obs_ant, obs_cap: @exmautoriz.obs_cap, obs_ot: @exmautoriz.obs_ot, obs_rt: @exmautoriz.obs_rt, proyecto_minero_id: @exmautoriz.proyecto_minero_id, proyecto_minero_id: @exmautoriz.proyecto_minero_id, supplier_id: @exmautoriz.supplier_id, tipo_antecedent_id: @exmautoriz.tipo_antecedent_id, tipo_revision_tecnica: @exmautoriz.tipo_revision_tecnica, tipo_tramit_id: @exmautoriz.tipo_tramit_id, tramit_id: @exmautoriz.tramit_id, tramite: @exmautoriz.tramite, truck_id: @exmautoriz.truck_id }
    assert_redirected_to exmautoriz_path(assigns(:exmautoriz))
  end

  test "should destroy exmautoriz" do
    assert_difference('Exmautoriz.count', -1) do
      delete :destroy, id: @exmautoriz
    end

    assert_redirected_to exmautorizs_path
  end
end
