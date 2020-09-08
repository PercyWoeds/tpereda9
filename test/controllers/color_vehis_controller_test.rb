require 'test_helper'

class ColorVehisControllerTest < ActionController::TestCase
  setup do
    @color_vehi = color_vehis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:color_vehis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create color_vehi" do
    assert_difference('ColorVehi.count') do
      post :create, color_vehi: { code: @color_vehi.code, company_id: @color_vehi.company_id, name: @color_vehi.name, user_id: @color_vehi.user_id }
    end

    assert_redirected_to color_vehi_path(assigns(:color_vehi))
  end

  test "should show color_vehi" do
    get :show, id: @color_vehi
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @color_vehi
    assert_response :success
  end

  test "should update color_vehi" do
    patch :update, id: @color_vehi, color_vehi: { code: @color_vehi.code, company_id: @color_vehi.company_id, name: @color_vehi.name, user_id: @color_vehi.user_id }
    assert_redirected_to color_vehi_path(assigns(:color_vehi))
  end

  test "should destroy color_vehi" do
    assert_difference('ColorVehi.count', -1) do
      delete :destroy, id: @color_vehi
    end

    assert_redirected_to color_vehis_path
  end
end
