require 'test_helper'

class TipoTramitsControllerTest < ActionController::TestCase
  setup do
    @tipo_tramit = tipo_tramits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_tramits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_tramit" do
    assert_difference('TipoTramit.count') do
      post :create, tipo_tramit: { code: @tipo_tramit.code, name: @tipo_tramit.name }
    end

    assert_redirected_to tipo_tramit_path(assigns(:tipo_tramit))
  end

  test "should show tipo_tramit" do
    get :show, id: @tipo_tramit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_tramit
    assert_response :success
  end

  test "should update tipo_tramit" do
    patch :update, id: @tipo_tramit, tipo_tramit: { code: @tipo_tramit.code, name: @tipo_tramit.name }
    assert_redirected_to tipo_tramit_path(assigns(:tipo_tramit))
  end

  test "should destroy tipo_tramit" do
    assert_difference('TipoTramit.count', -1) do
      delete :destroy, id: @tipo_tramit
    end

    assert_redirected_to tipo_tramits_path
  end
end
