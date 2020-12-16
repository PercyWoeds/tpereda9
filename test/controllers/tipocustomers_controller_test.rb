require 'test_helper'

class TipocustomersControllerTest < ActionController::TestCase
  setup do
    @tipocustomer = tipocustomers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipocustomers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipocustomer" do
    assert_difference('Tipocustomer.count') do
      post :create, tipocustomer: { co: @tipocustomer.co, code: @tipocustomer.code, company_id: @tipocustomer.company_id, name: @tipocustomer.name, user_id: @tipocustomer.user_id }
    end

    assert_redirected_to tipocustomer_path(assigns(:tipocustomer))
  end

  test "should show tipocustomer" do
    get :show, id: @tipocustomer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipocustomer
    assert_response :success
  end

  test "should update tipocustomer" do
    patch :update, id: @tipocustomer, tipocustomer: { co: @tipocustomer.co, code: @tipocustomer.code, company_id: @tipocustomer.company_id, name: @tipocustomer.name, user_id: @tipocustomer.user_id }
    assert_redirected_to tipocustomer_path(assigns(:tipocustomer))
  end

  test "should destroy tipocustomer" do
    assert_difference('Tipocustomer.count', -1) do
      delete :destroy, id: @tipocustomer
    end

    assert_redirected_to tipocustomers_path
  end
end
