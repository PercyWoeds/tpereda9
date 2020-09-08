require 'test_helper'

class ConfigVehisControllerTest < ActionController::TestCase
  setup do
    @config_vehi = config_vehis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:config_vehis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create config_vehi" do
    assert_difference('ConfigVehi.count') do
      post :create, config_vehi: { code: @config_vehi.code, company_id: @config_vehi.company_id, name: @config_vehi.name, user_id: @config_vehi.user_id }
    end

    assert_redirected_to config_vehi_path(assigns(:config_vehi))
  end

  test "should show config_vehi" do
    get :show, id: @config_vehi
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @config_vehi
    assert_response :success
  end

  test "should update config_vehi" do
    patch :update, id: @config_vehi, config_vehi: { code: @config_vehi.code, company_id: @config_vehi.company_id, name: @config_vehi.name, user_id: @config_vehi.user_id }
    assert_redirected_to config_vehi_path(assigns(:config_vehi))
  end

  test "should destroy config_vehi" do
    assert_difference('ConfigVehi.count', -1) do
      delete :destroy, id: @config_vehi
    end

    assert_redirected_to config_vehis_path
  end
end
