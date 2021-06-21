require 'test_helper'

class MntosControllerTest < ActionController::TestCase
  setup do
    @mnto = mntos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mntos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mnto" do
    assert_difference('Mnto.count') do
      post :create, mnto: { code: @mnto.code, date_processed: @mnto.date_processed, division_id: @mnto.division_id, fecha2: @mnto.fecha2, fecha: @mnto.fecha, km_actual: @mnto.km_actual, km_programado: @mnto.km_programado, ocupacion_id: @mnto.ocupacion_id, processed: @mnto.processed, truck_id: @mnto.truck_id, user_id: @mnto.user_id }
    end

    assert_redirected_to mnto_path(assigns(:mnto))
  end

  test "should show mnto" do
    get :show, id: @mnto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mnto
    assert_response :success
  end

  test "should update mnto" do
    patch :update, id: @mnto, mnto: { code: @mnto.code, date_processed: @mnto.date_processed, division_id: @mnto.division_id, fecha2: @mnto.fecha2, fecha: @mnto.fecha, km_actual: @mnto.km_actual, km_programado: @mnto.km_programado, ocupacion_id: @mnto.ocupacion_id, processed: @mnto.processed, truck_id: @mnto.truck_id, user_id: @mnto.user_id }
    assert_redirected_to mnto_path(assigns(:mnto))
  end

  test "should destroy mnto" do
    assert_difference('Mnto.count', -1) do
      delete :destroy, id: @mnto
    end

    assert_redirected_to mntos_path
  end
end
