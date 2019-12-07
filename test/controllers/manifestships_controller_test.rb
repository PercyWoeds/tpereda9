require 'test_helper'

class ManifestshipsControllerTest < ActionController::TestCase
  setup do
    @manifestship = manifestships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manifestships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manifestship" do
    assert_difference('Manifestship.count') do
      post :create, manifestship: { manifest_id: @manifestship.manifest_id, tranportorder_id: @manifestship.tranportorder_id }
    end

    assert_redirected_to manifestship_path(assigns(:manifestship))
  end

  test "should show manifestship" do
    get :show, id: @manifestship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manifestship
    assert_response :success
  end

  test "should update manifestship" do
    patch :update, id: @manifestship, manifestship: { manifest_id: @manifestship.manifest_id, tranportorder_id: @manifestship.tranportorder_id }
    assert_redirected_to manifestship_path(assigns(:manifestship))
  end

  test "should destroy manifestship" do
    assert_difference('Manifestship.count', -1) do
      delete :destroy, id: @manifestship
    end

    assert_redirected_to manifestships_path
  end
end
