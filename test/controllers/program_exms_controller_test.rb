require 'test_helper'

class ProgramExmsControllerTest < ActionController::TestCase
  setup do
    @program_exm = program_exms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_exms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_exm" do
    assert_difference('ProgramExm.count') do
      post :create, program_exm: { em: @program_exm.em, employee_id: @program_exm.employee_id, fecha: @program_exm.fecha, horaingbase: @program_exm.horaingbase, ind: @program_exm.ind, inicio: @program_exm.inicio, lo: @program_exm.lo, observa: @program_exm.observa, tema: @program_exm.tema, termino: @program_exm.termino, totalhora: @program_exm.totalhora, tr: @program_exm.tr }
    end

    assert_redirected_to program_exm_path(assigns(:program_exm))
  end

  test "should show program_exm" do
    get :show, id: @program_exm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @program_exm
    assert_response :success
  end

  test "should update program_exm" do
    patch :update, id: @program_exm, program_exm: { em: @program_exm.em, employee_id: @program_exm.employee_id, fecha: @program_exm.fecha, horaingbase: @program_exm.horaingbase, ind: @program_exm.ind, inicio: @program_exm.inicio, lo: @program_exm.lo, observa: @program_exm.observa, tema: @program_exm.tema, termino: @program_exm.termino, totalhora: @program_exm.totalhora, tr: @program_exm.tr }
    assert_redirected_to program_exm_path(assigns(:program_exm))
  end

  test "should destroy program_exm" do
    assert_difference('ProgramExm.count', -1) do
      delete :destroy, id: @program_exm
    end

    assert_redirected_to program_exms_path
  end
end
