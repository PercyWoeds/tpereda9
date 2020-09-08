require 'test_helper'

class ClaseCatsControllerTest < ActionController::TestCase
  setup do
    @clase_cat = clase_cats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clase_cats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clase_cat" do
    assert_difference('ClaseCat.count') do
      post :create, clase_cat: { code: @clase_cat.code, company_id: @clase_cat.company_id, name: @clase_cat.name, user_id: @clase_cat.user_id }
    end

    assert_redirected_to clase_cat_path(assigns(:clase_cat))
  end

  test "should show clase_cat" do
    get :show, id: @clase_cat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @clase_cat
    assert_response :success
  end

  test "should update clase_cat" do
    patch :update, id: @clase_cat, clase_cat: { code: @clase_cat.code, company_id: @clase_cat.company_id, name: @clase_cat.name, user_id: @clase_cat.user_id }
    assert_redirected_to clase_cat_path(assigns(:clase_cat))
  end

  test "should destroy clase_cat" do
    assert_difference('ClaseCat.count', -1) do
      delete :destroy, id: @clase_cat
    end

    assert_redirected_to clase_cats_path
  end
end
