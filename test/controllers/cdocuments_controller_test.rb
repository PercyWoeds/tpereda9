require 'test_helper'

class CdocumentsControllerTest < ActionController::TestCase
  setup do
    @cdocument = cdocuments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cdocuments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cdocument" do
    assert_difference('Cdocument.count') do
      post :create, cdocument: { ap_caducidad: @cdocument.ap_caducidad, ap_emision: @cdocument.ap_emision, app_caducidad: @cdocument.app_caducidad, app_emision: @cdocument.app_emision, categoria: @cdocument.categoria, categoria_especial: @cdocument.categoria_especial, cv_documentado: @cdocument.cv_documentado, dni: @cdocument.dni, dni_caducidad: @cdocument.dni_caducidad, dni_emision: @cdocument.dni_emision, employee_id: @cdocument.employee_id, exp_licencia2: @cdocument.exp_licencia2, exp_licencia: @cdocument.exp_licencia, experiencia: @cdocument.experiencia, iqbf: @cdocument.iqbf, lugar: @cdocument.lugar, nivel_educativo: @cdocument.nivel_educativo, rev_licencia: @cdocument.rev_licencia, rev_licencia: @cdocument.rev_licencia }
    end

    assert_redirected_to cdocument_path(assigns(:cdocument))
  end

  test "should show cdocument" do
    get :show, id: @cdocument
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cdocument
    assert_response :success
  end

  test "should update cdocument" do
    patch :update, id: @cdocument, cdocument: { ap_caducidad: @cdocument.ap_caducidad, ap_emision: @cdocument.ap_emision, app_caducidad: @cdocument.app_caducidad, app_emision: @cdocument.app_emision, categoria: @cdocument.categoria, categoria_especial: @cdocument.categoria_especial, cv_documentado: @cdocument.cv_documentado, dni: @cdocument.dni, dni_caducidad: @cdocument.dni_caducidad, dni_emision: @cdocument.dni_emision, employee_id: @cdocument.employee_id, exp_licencia2: @cdocument.exp_licencia2, exp_licencia: @cdocument.exp_licencia, experiencia: @cdocument.experiencia, iqbf: @cdocument.iqbf, lugar: @cdocument.lugar, nivel_educativo: @cdocument.nivel_educativo, rev_licencia: @cdocument.rev_licencia, rev_licencia: @cdocument.rev_licencia }
    assert_redirected_to cdocument_path(assigns(:cdocument))
  end

  test "should destroy cdocument" do
    assert_difference('Cdocument.count', -1) do
      delete :destroy, id: @cdocument
    end

    assert_redirected_to cdocuments_path
  end
end
