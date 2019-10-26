require 'test_helper'

class CotizacionsControllerTest < ActionController::TestCase
  setup do
    @cotizacion = cotizacions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cotizacions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cotizacion" do
    assert_difference('Cotizacion.count') do
      post :create, cotizacion: { code: @cotizacion.code, comments: @cotizacion.comments, customer_id: @cotizacion.customer_id, fecha: @cotizacion.fecha, processed: @cotizacion.processed, punto2_id: @cotizacion.punto2_id, punto_id: @cotizacion.punto_id, tarifa: @cotizacion.tarifa, tipocargue_id: @cotizacion.tipocargue_id }
    end

    assert_redirected_to cotizacion_path(assigns(:cotizacion))
  end

  test "should show cotizacion" do
    get :show, id: @cotizacion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cotizacion
    assert_response :success
  end

  test "should update cotizacion" do
    patch :update, id: @cotizacion, cotizacion: { code: @cotizacion.code, comments: @cotizacion.comments, customer_id: @cotizacion.customer_id, fecha: @cotizacion.fecha, processed: @cotizacion.processed, punto2_id: @cotizacion.punto2_id, punto_id: @cotizacion.punto_id, tarifa: @cotizacion.tarifa, tipocargue_id: @cotizacion.tipocargue_id }
    assert_redirected_to cotizacion_path(assigns(:cotizacion))
  end

  test "should destroy cotizacion" do
    assert_difference('Cotizacion.count', -1) do
      delete :destroy, id: @cotizacion
    end

    assert_redirected_to cotizacions_path
  end
end
