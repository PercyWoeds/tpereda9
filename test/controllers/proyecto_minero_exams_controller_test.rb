require 'test_helper'

class ProyectoMineroExamsControllerTest < ActionController::TestCase
  setup do
    @proyecto_minero_exam = proyecto_minero_exams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyecto_minero_exams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyecto_minero_exam" do
    assert_difference('ProyectoMineroExam.count') do
      post :create, proyecto_minero_exam: { fecha: @proyecto_minero_exam.fecha, observacion: @proyecto_minero_exam.observacion, proyecto_minero: @proyecto_minero_exam.proyecto_minero, reference: @proyecto_minero_exam.reference }
    end

    assert_redirected_to proyecto_minero_exam_path(assigns(:proyecto_minero_exam))
  end

  test "should show proyecto_minero_exam" do
    get :show, id: @proyecto_minero_exam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proyecto_minero_exam
    assert_response :success
  end

  test "should update proyecto_minero_exam" do
    patch :update, id: @proyecto_minero_exam, proyecto_minero_exam: { fecha: @proyecto_minero_exam.fecha, observacion: @proyecto_minero_exam.observacion, proyecto_minero: @proyecto_minero_exam.proyecto_minero, reference: @proyecto_minero_exam.reference }
    assert_redirected_to proyecto_minero_exam_path(assigns(:proyecto_minero_exam))
  end

  test "should destroy proyecto_minero_exam" do
    assert_difference('ProyectoMineroExam.count', -1) do
      delete :destroy, id: @proyecto_minero_exam
    end

    assert_redirected_to proyecto_minero_exams_path
  end
end
