require 'test_helper'

class RqdetailsControllerTest < ActionController::TestCase
  setup do
    @rqdetail = rqdetails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rqdetails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rqdetail" do
    assert_difference('Rqdetail.count') do
      post :create, rqdetail: { codigo: @rqdetail.codigo, descrip: @rqdetail.descrip, placa_destino: @rqdetail.placa_destino, qty: @rqdetail.qty, requerimiento_id: @rqdetail.requerimiento_id, string: @rqdetail.string, unidad_id: @rqdetail.unidad_id }
    end

    assert_redirected_to rqdetail_path(assigns(:rqdetail))
  end

  test "should show rqdetail" do
    get :show, id: @rqdetail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rqdetail
    assert_response :success
  end

  test "should update rqdetail" do
    patch :update, id: @rqdetail, rqdetail: { codigo: @rqdetail.codigo, descrip: @rqdetail.descrip, placa_destino: @rqdetail.placa_destino, qty: @rqdetail.qty, requerimiento_id: @rqdetail.requerimiento_id, string: @rqdetail.string, unidad_id: @rqdetail.unidad_id }
    assert_redirected_to rqdetail_path(assigns(:rqdetail))
  end

  test "should destroy rqdetail" do
    assert_difference('Rqdetail.count', -1) do
      delete :destroy, id: @rqdetail
    end

    assert_redirected_to rqdetails_path
  end
end
