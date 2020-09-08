require 'test_helper'

class TipoUnidadsControllerTest < ActionController::TestCase
  setup do
    @tipo_unidad = tipo_unidads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_unidads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_unidad" do
    assert_difference('TipoUnidad.count') do
      post :create, tipo_unidad: { code: @tipo_unidad.code, company_id: @tipo_unidad.company_id, name: @tipo_unidad.name, user_id: @tipo_unidad.user_id }
    end

    assert_redirected_to tipo_unidad_path(assigns(:tipo_unidad))
  end

  test "should show tipo_unidad" do
    get :show, id: @tipo_unidad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_unidad
    assert_response :success
  end

  test "should update tipo_unidad" do
    patch :update, id: @tipo_unidad, tipo_unidad: { code: @tipo_unidad.code, company_id: @tipo_unidad.company_id, name: @tipo_unidad.name, user_id: @tipo_unidad.user_id }
    assert_redirected_to tipo_unidad_path(assigns(:tipo_unidad))
  end

  test "should destroy tipo_unidad" do
    assert_difference('TipoUnidad.count', -1) do
      delete :destroy, id: @tipo_unidad
    end

    assert_redirected_to tipo_unidads_path
  end
end
