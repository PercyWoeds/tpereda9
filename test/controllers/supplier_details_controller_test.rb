require 'test_helper'

class SupplierDetailsControllerTest < ActionController::TestCase
  setup do
    @supplier_detail = supplier_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supplier_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supplier_detail" do
    assert_difference('SupplierDetail.count') do
      post :create, supplier_detail: { area: @supplier_detail.area, cargo: @supplier_detail.cargo, correo: @supplier_detail.correo, name: @supplier_detail.name, supplier_id: @supplier_detail.supplier_id, telefono: @supplier_detail.telefono }
    end

    assert_redirected_to supplier_detail_path(assigns(:supplier_detail))
  end

  test "should show supplier_detail" do
    get :show, id: @supplier_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @supplier_detail
    assert_response :success
  end

  test "should update supplier_detail" do
    patch :update, id: @supplier_detail, supplier_detail: { area: @supplier_detail.area, cargo: @supplier_detail.cargo, correo: @supplier_detail.correo, name: @supplier_detail.name, supplier_id: @supplier_detail.supplier_id, telefono: @supplier_detail.telefono }
    assert_redirected_to supplier_detail_path(assigns(:supplier_detail))
  end

  test "should destroy supplier_detail" do
    assert_difference('SupplierDetail.count', -1) do
      delete :destroy, id: @supplier_detail
    end

    assert_redirected_to supplier_details_path
  end
end
