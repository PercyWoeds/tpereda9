require 'test_helper'

class CpagarsControllerTest < ActionController::TestCase
  setup do
    @cpagar = cpagars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cpagars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cpagar" do
    assert_difference('Cpagar.count') do
      post :create, cpagar: { bank_acount_id: @cpagar.bank_acount_id, code: @cpagar.code, comments: @cpagar.comments, company_id: @cpagar.company_id, date_processed: @cpagar.date_processed, division_id: @cpagar.division_id, document_id: @cpagar.document_id, documento: @cpagar.documento, fecha1: @cpagar.fecha1, fecha2: @cpagar.fecha2, location_id: @cpagar.location_id, nrooperacion: @cpagar.nrooperacion, operacion: @cpagar.operacion, processed: @cpagar.processed, supplier_id: @cpagar.supplier_id, tm: @cpagar.tm, total: @cpagar.total, user_id: @cpagar.user_id }
    end

    assert_redirected_to cpagar_path(assigns(:cpagar))
  end

  test "should show cpagar" do
    get :show, id: @cpagar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cpagar
    assert_response :success
  end

  test "should update cpagar" do
    patch :update, id: @cpagar, cpagar: { bank_acount_id: @cpagar.bank_acount_id, code: @cpagar.code, comments: @cpagar.comments, company_id: @cpagar.company_id, date_processed: @cpagar.date_processed, division_id: @cpagar.division_id, document_id: @cpagar.document_id, documento: @cpagar.documento, fecha1: @cpagar.fecha1, fecha2: @cpagar.fecha2, location_id: @cpagar.location_id, nrooperacion: @cpagar.nrooperacion, operacion: @cpagar.operacion, processed: @cpagar.processed, supplier_id: @cpagar.supplier_id, tm: @cpagar.tm, total: @cpagar.total, user_id: @cpagar.user_id }
    assert_redirected_to cpagar_path(assigns(:cpagar))
  end

  test "should destroy cpagar" do
    assert_difference('Cpagar.count', -1) do
      delete :destroy, id: @cpagar
    end

    assert_redirected_to cpagars_path
  end
end
