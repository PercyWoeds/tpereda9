require 'test_helper'

class ServiceExtensionsControllerTest < ActionController::TestCase
  setup do
    @service_extension = service_extensions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_extensions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service_extension" do
    assert_difference('ServiceExtension.count') do
      post :create, service_extension: { code: @service_extension.code, name: @service_extension.name, servicebuy_id: @service_extension.servicebuy_id }
    end

    assert_redirected_to service_extension_path(assigns(:service_extension))
  end

  test "should show service_extension" do
    get :show, id: @service_extension
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_extension
    assert_response :success
  end

  test "should update service_extension" do
    patch :update, id: @service_extension, service_extension: { code: @service_extension.code, name: @service_extension.name, servicebuy_id: @service_extension.servicebuy_id }
    assert_redirected_to service_extension_path(assigns(:service_extension))
  end

  test "should destroy service_extension" do
    assert_difference('ServiceExtension.count', -1) do
      delete :destroy, id: @service_extension
    end

    assert_redirected_to service_extensions_path
  end
end
