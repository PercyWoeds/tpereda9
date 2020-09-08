require 'test_helper'

class ConductorsControllerTest < ActionController::TestCase
  setup do
    @conductor = conductors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conductors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conductor" do
    assert_difference('Conductor.count') do
      post :create, conductor: { active: @conductor.active, anio: @conductor.anio, ap_caducidad: @conductor.ap_caducidad, ap_emision: @conductor.ap_emision, ape_caducidad: @conductor.ape_caducidad, ape_emision: @conductor.ape_emision, categoria: @conductor.categoria, categoria_especial: @conductor.categoria_especial, company_id: @conductor.company_id, dni_caducidad: @conductor.dni_caducidad, dni_emision: @conductor.dni_emision, employees_id: @conductor.employees_id, expedicion_licencia: @conductor.expedicion_licencia, expedicion_licencia_especial: @conductor.expedicion_licencia_especial, fecha_emision: @conductor.fecha_emision, iqbf: @conductor.iqbf, licencia: @conductor.licencia, lugar: @conductor.lugar, revalidacion_licencia: @conductor.revalidacion_licencia, user_id: @conductor.user_id }
    end

    assert_redirected_to conductor_path(assigns(:conductor))
  end

  test "should show conductor" do
    get :show, id: @conductor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conductor
    assert_response :success
  end

  test "should update conductor" do
    patch :update, id: @conductor, conductor: { active: @conductor.active, anio: @conductor.anio, ap_caducidad: @conductor.ap_caducidad, ap_emision: @conductor.ap_emision, ape_caducidad: @conductor.ape_caducidad, ape_emision: @conductor.ape_emision, categoria: @conductor.categoria, categoria_especial: @conductor.categoria_especial, company_id: @conductor.company_id, dni_caducidad: @conductor.dni_caducidad, dni_emision: @conductor.dni_emision, employees_id: @conductor.employees_id, expedicion_licencia: @conductor.expedicion_licencia, expedicion_licencia_especial: @conductor.expedicion_licencia_especial, fecha_emision: @conductor.fecha_emision, iqbf: @conductor.iqbf, licencia: @conductor.licencia, lugar: @conductor.lugar, revalidacion_licencia: @conductor.revalidacion_licencia, user_id: @conductor.user_id }
    assert_redirected_to conductor_path(assigns(:conductor))
  end

  test "should destroy conductor" do
    assert_difference('Conductor.count', -1) do
      delete :destroy, id: @conductor
    end

    assert_redirected_to conductors_path
  end
end
