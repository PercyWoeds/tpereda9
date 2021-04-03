require 'test_helper'

class ProgramExamenControllerTest < ActionController::TestCase
  setup do
    @program_examan = program_examen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_examen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_examan" do
    assert_difference('ProgramExaman.count') do
      post :create, program_examan: { code: @program_examan.code, date_processed: @program_examan.date_processed, fecha: @program_examan.fecha, processed: @program_examan.processed }
    end

    assert_redirected_to program_examan_path(assigns(:program_examan))
  end

  test "should show program_examan" do
    get :show, id: @program_examan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @program_examan
    assert_response :success
  end

  test "should update program_examan" do
    patch :update, id: @program_examan, program_examan: { code: @program_examan.code, date_processed: @program_examan.date_processed, fecha: @program_examan.fecha, processed: @program_examan.processed }
    assert_redirected_to program_examan_path(assigns(:program_examan))
  end

  test "should destroy program_examan" do
    assert_difference('ProgramExaman.count', -1) do
      delete :destroy, id: @program_examan
    end

    assert_redirected_to program_examen_path
  end
end
