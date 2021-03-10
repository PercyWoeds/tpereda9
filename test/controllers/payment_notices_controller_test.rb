require 'test_helper'

class PaymentNoticesControllerTest < ActionController::TestCase
  setup do
    @payment_notice = payment_notices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment_notice" do
    assert_difference('PaymentNotice.count') do
      post :create, payment_notice: { asunto: @payment_notice.asunto, code: @payment_notice.code, concepto: @payment_notice.concepto, date_processed: @payment_notice.date_processed, employee_id: @payment_notice.employee_id, fecha: @payment_notice.fecha, processed: @payment_notice.processed, total: @payment_notice.total }
    end

    assert_redirected_to payment_notice_path(assigns(:payment_notice))
  end

  test "should show payment_notice" do
    get :show, id: @payment_notice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payment_notice
    assert_response :success
  end

  test "should update payment_notice" do
    patch :update, id: @payment_notice, payment_notice: { asunto: @payment_notice.asunto, code: @payment_notice.code, concepto: @payment_notice.concepto, date_processed: @payment_notice.date_processed, employee_id: @payment_notice.employee_id, fecha: @payment_notice.fecha, processed: @payment_notice.processed, total: @payment_notice.total }
    assert_redirected_to payment_notice_path(assigns(:payment_notice))
  end

  test "should destroy payment_notice" do
    assert_difference('PaymentNotice.count', -1) do
      delete :destroy, id: @payment_notice
    end

    assert_redirected_to payment_notices_path
  end
end
