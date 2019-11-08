require 'test_helper'

class ContratosControllerTest < ActionController::TestCase
  setup do
    @contrato = contratos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contratos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contrato" do
    assert_difference('Contrato.count') do
      post :create, contrato: { comments: @contrato.comments, division_id: @contrato.division_id, employee_id: @contrato.employee_id, fecha_fin: @contrato.fecha_fin, fecha_inicio: @contrato.fecha_inicio, fecha_suscripcion: @contrato.fecha_suscripcion, location_id: @contrato.location_id, modalidad_id: @contrato.modalidad_id, moneda_id: @contrato.moneda_id, reingreso: @contrato.reingreso, submodalidad_id: @contrato.submodalidad_id, sueldo: @contrato.sueldo, tipocontrato_id: @contrato.tipocontrato_id, tiporemuneracion_id: @contrato.tiporemuneracion_id }
    end

    assert_redirected_to contrato_path(assigns(:contrato))
  end

  test "should show contrato" do
    get :show, id: @contrato
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contrato
    assert_response :success
  end

  test "should update contrato" do
    patch :update, id: @contrato, contrato: { comments: @contrato.comments, division_id: @contrato.division_id, employee_id: @contrato.employee_id, fecha_fin: @contrato.fecha_fin, fecha_inicio: @contrato.fecha_inicio, fecha_suscripcion: @contrato.fecha_suscripcion, location_id: @contrato.location_id, modalidad_id: @contrato.modalidad_id, moneda_id: @contrato.moneda_id, reingreso: @contrato.reingreso, submodalidad_id: @contrato.submodalidad_id, sueldo: @contrato.sueldo, tipocontrato_id: @contrato.tipocontrato_id, tiporemuneracion_id: @contrato.tiporemuneracion_id }
    assert_redirected_to contrato_path(assigns(:contrato))
  end

  test "should destroy contrato" do
    assert_difference('Contrato.count', -1) do
      delete :destroy, id: @contrato
    end

    assert_redirected_to contratos_path
  end
end
