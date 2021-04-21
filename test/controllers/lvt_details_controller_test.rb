require 'test_helper'

class LvtDetailsControllerTest < ActionController::TestCase
  setup do
    @lvt_detail = lvt_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lvt_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lvt_detail" do
    assert_difference('LvtDetail.count') do
      post :create, lvt_detail: { detalle: @lvt_detail.detalle, document_id: @lvt_detail.document_id, documento: @lvt_detail.documento, fecha: @lvt_detail.fecha, gasto_id: @lvt_detail.gasto_id, lvt_id: @lvt_detail.lvt_id, supplier_id: @lvt_detail.supplier_id, td: @lvt_detail.td, total: @lvt_detail.total }
    end

    assert_redirected_to lvt_detail_path(assigns(:lvt_detail))
  end

  test "should show lvt_detail" do
    get :show, id: @lvt_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lvt_detail
    assert_response :success
  end

  test "should update lvt_detail" do
    patch :update, id: @lvt_detail, lvt_detail: { detalle: @lvt_detail.detalle, document_id: @lvt_detail.document_id, documento: @lvt_detail.documento, fecha: @lvt_detail.fecha, gasto_id: @lvt_detail.gasto_id, lvt_id: @lvt_detail.lvt_id, supplier_id: @lvt_detail.supplier_id, td: @lvt_detail.td, total: @lvt_detail.total }
    assert_redirected_to lvt_detail_path(assigns(:lvt_detail))
  end

  test "should destroy lvt_detail" do
    assert_difference('LvtDetail.count', -1) do
      delete :destroy, id: @lvt_detail
    end

    assert_redirected_to lvt_details_path
  end
end
