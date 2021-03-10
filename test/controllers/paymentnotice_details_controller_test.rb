require 'test_helper'

class PaymentnoticeDetailsControllerTest < ActionController::TestCase
  setup do
    @paymentnotice_detail = paymentnotice_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paymentnotice_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paymentnotice_detail" do
    assert_difference('PaymentnoticeDetail.count') do
      post :create, paymentnotice_detail: { descrip: @paymentnotice_detail.descrip, fecha_culmina: @paymentnotice_detail.fecha_culmina, fecha_inicio: @paymentnotice_detail.fecha_inicio, igv: @paymentnotice_detail.igv, lugar: @paymentnotice_detail.lugar, nro_compro: @paymentnotice_detail.nro_compro, nro_documento: @paymentnotice_detail.nro_documento, observa: @paymentnotice_detail.observa, payment_notices_id: @paymentnotice_detail.payment_notices_id, price_unit: @paymentnotice_detail.price_unit, sub_total: @paymentnotice_detail.sub_total, total: @paymentnotice_detail.total, total: @paymentnotice_detail.total }
    end

    assert_redirected_to paymentnotice_detail_path(assigns(:paymentnotice_detail))
  end

  test "should show paymentnotice_detail" do
    get :show, id: @paymentnotice_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @paymentnotice_detail
    assert_response :success
  end

  test "should update paymentnotice_detail" do
    patch :update, id: @paymentnotice_detail, paymentnotice_detail: { descrip: @paymentnotice_detail.descrip, fecha_culmina: @paymentnotice_detail.fecha_culmina, fecha_inicio: @paymentnotice_detail.fecha_inicio, igv: @paymentnotice_detail.igv, lugar: @paymentnotice_detail.lugar, nro_compro: @paymentnotice_detail.nro_compro, nro_documento: @paymentnotice_detail.nro_documento, observa: @paymentnotice_detail.observa, payment_notices_id: @paymentnotice_detail.payment_notices_id, price_unit: @paymentnotice_detail.price_unit, sub_total: @paymentnotice_detail.sub_total, total: @paymentnotice_detail.total, total: @paymentnotice_detail.total }
    assert_redirected_to paymentnotice_detail_path(assigns(:paymentnotice_detail))
  end

  test "should destroy paymentnotice_detail" do
    assert_difference('PaymentnoticeDetail.count', -1) do
      delete :destroy, id: @paymentnotice_detail
    end

    assert_redirected_to paymentnotice_details_path
  end
end
