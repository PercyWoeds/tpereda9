require 'test_helper'

class QuotationDetailsControllerTest < ActionController::TestCase
  setup do
    @quotation_detail = quotation_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotation_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quotation_detail" do
    assert_difference('QuotationDetail.count') do
      post :create, quotation_detail: { costo1: @quotation_detail.costo1, costo2: @quotation_detail.costo2, descrip: @quotation_detail.descrip, item: @quotation_detail.item, quotations: @quotation_detail.quotations, references: @quotation_detail.references, total: @quotation_detail.total }
    end

    assert_redirected_to quotation_detail_path(assigns(:quotation_detail))
  end

  test "should show quotation_detail" do
    get :show, id: @quotation_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quotation_detail
    assert_response :success
  end

  test "should update quotation_detail" do
    patch :update, id: @quotation_detail, quotation_detail: { costo1: @quotation_detail.costo1, costo2: @quotation_detail.costo2, descrip: @quotation_detail.descrip, item: @quotation_detail.item, quotations: @quotation_detail.quotations, references: @quotation_detail.references, total: @quotation_detail.total }
    assert_redirected_to quotation_detail_path(assigns(:quotation_detail))
  end

  test "should destroy quotation_detail" do
    assert_difference('QuotationDetail.count', -1) do
      delete :destroy, id: @quotation_detail
    end

    assert_redirected_to quotation_details_path
  end
end
