require 'test_helper'

class CpagarDetailsControllerTest < ActionController::TestCase
  setup do
    @cpagar_detail = cpagar_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cpagar_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cpagar_detail" do
    assert_difference('CpagarDetail.count') do
      post :create, cpagar_detail: { cpagar_id: @cpagar_detail.cpagar_id, descrip: @cpagar_detail.descrip, document_id: @cpagar_detail.document_id, documento: @cpagar_detail.documento, supplier_id: @cpagar_detail.supplier_id, tm: @cpagar_detail.tm, total: @cpagar_detail.total }
    end

    assert_redirected_to cpagar_detail_path(assigns(:cpagar_detail))
  end

  test "should show cpagar_detail" do
    get :show, id: @cpagar_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cpagar_detail
    assert_response :success
  end

  test "should update cpagar_detail" do
    patch :update, id: @cpagar_detail, cpagar_detail: { cpagar_id: @cpagar_detail.cpagar_id, descrip: @cpagar_detail.descrip, document_id: @cpagar_detail.document_id, documento: @cpagar_detail.documento, supplier_id: @cpagar_detail.supplier_id, tm: @cpagar_detail.tm, total: @cpagar_detail.total }
    assert_redirected_to cpagar_detail_path(assigns(:cpagar_detail))
  end

  test "should destroy cpagar_detail" do
    assert_difference('CpagarDetail.count', -1) do
      delete :destroy, id: @cpagar_detail
    end

    assert_redirected_to cpagar_details_path
  end
end
