require 'test_helper'

class VueltoDetailsControllerTest < ActionController::TestCase
  setup do
    @vuelto_detail = vuelto_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vuelto_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vuelto_detail" do
    assert_difference('VueltoDetail.count') do
      post :create, vuelto_detail: { cout_id: @vuelto_detail.cout_id, egreso: @vuelto_detail.egreso, fecha: @vuelto_detail.fecha, flete: @vuelto_detail.flete, importe: @vuelto_detail.importe, observa: @vuelto_detail.observa, total: @vuelto_detail.total, vuelto_id: @vuelto_detail.vuelto_id }
    end

    assert_redirected_to vuelto_detail_path(assigns(:vuelto_detail))
  end

  test "should show vuelto_detail" do
    get :show, id: @vuelto_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vuelto_detail
    assert_response :success
  end

  test "should update vuelto_detail" do
    patch :update, id: @vuelto_detail, vuelto_detail: { cout_id: @vuelto_detail.cout_id, egreso: @vuelto_detail.egreso, fecha: @vuelto_detail.fecha, flete: @vuelto_detail.flete, importe: @vuelto_detail.importe, observa: @vuelto_detail.observa, total: @vuelto_detail.total, vuelto_id: @vuelto_detail.vuelto_id }
    assert_redirected_to vuelto_detail_path(assigns(:vuelto_detail))
  end

  test "should destroy vuelto_detail" do
    assert_difference('VueltoDetail.count', -1) do
      delete :destroy, id: @vuelto_detail
    end

    assert_redirected_to vuelto_details_path
  end
end
