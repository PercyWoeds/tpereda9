require 'test_helper'

class ProyectoExamsControllerTest < ActionController::TestCase
  setup do
    @proyecto_exam = proyecto_exams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyecto_exams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyecto_exam" do
    assert_difference('ProyectoExam.count') do
      post :create, proyecto_exam: { employee_id: @proyecto_exam.employee_id, proyecto_minero_exam_id: @proyecto_exam.proyecto_minero_exam_id }
    end

    assert_redirected_to proyecto_exam_path(assigns(:proyecto_exam))
  end

  test "should show proyecto_exam" do
    get :show, id: @proyecto_exam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proyecto_exam
    assert_response :success
  end

  test "should update proyecto_exam" do
    patch :update, id: @proyecto_exam, proyecto_exam: { employee_id: @proyecto_exam.employee_id, proyecto_minero_exam_id: @proyecto_exam.proyecto_minero_exam_id }
    assert_redirected_to proyecto_exam_path(assigns(:proyecto_exam))
  end

  test "should destroy proyecto_exam" do
    assert_difference('ProyectoExam.count', -1) do
      delete :destroy, id: @proyecto_exam
    end

    assert_redirected_to proyecto_exams_path
  end
end
