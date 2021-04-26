require 'test_helper'

class PexesControllerTest < ActionController::TestCase
  setup do
    @pex = pexes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pexes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pex" do
    assert_difference('Pex.count') do
      post :create, pex: { categoria: @pex.categoria, doc: @pex.doc, fecha_apro: @pex.fecha_apro, fecha_compro: @pex.fecha_compro, fecha_fin: @pex.fecha_fin, fecha_inicio: @pex.fecha_inicio, hora_apro: @pex.hora_apro, hora_fin: @pex.hora_fin, hora_inicio: @pex.hora_inicio, importe: @pex.importe, nro_compro: @pex.nro_compro, nromiddia: @pex.nromiddia, pista: @pex.pista, placa: @pex.placa, plaza: @pex.plaza, razon: @pex.razon, red: @pex.red, ruc_red: @pex.ruc_red }
    end

    assert_redirected_to pex_path(assigns(:pex))
  end

  test "should show pex" do
    get :show, id: @pex
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pex
    assert_response :success
  end

  test "should update pex" do
    patch :update, id: @pex, pex: { categoria: @pex.categoria, doc: @pex.doc, fecha_apro: @pex.fecha_apro, fecha_compro: @pex.fecha_compro, fecha_fin: @pex.fecha_fin, fecha_inicio: @pex.fecha_inicio, hora_apro: @pex.hora_apro, hora_fin: @pex.hora_fin, hora_inicio: @pex.hora_inicio, importe: @pex.importe, nro_compro: @pex.nro_compro, nromiddia: @pex.nromiddia, pista: @pex.pista, placa: @pex.placa, plaza: @pex.plaza, razon: @pex.razon, red: @pex.red, ruc_red: @pex.ruc_red }
    assert_redirected_to pex_path(assigns(:pex))
  end

  test "should destroy pex" do
    assert_difference('Pex.count', -1) do
      delete :destroy, id: @pex
    end

    assert_redirected_to pexes_path
  end
end
