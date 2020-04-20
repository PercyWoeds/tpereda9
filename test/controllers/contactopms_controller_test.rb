require 'test_helper'

class ContactopmsControllerTest < ActionController::TestCase
  setup do
    @contactopm = contactopms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contactopms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contactopm" do
    assert_difference('Contactopm.count') do
      post :create, contactopm: { proyecto_minero_id: @contactopm.proyecto_minero_id }
    end

    assert_redirected_to contactopm_path(assigns(:contactopm))
  end

  test "should show contactopm" do
    get :show, id: @contactopm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contactopm
    assert_response :success
  end

  test "should update contactopm" do
    patch :update, id: @contactopm, contactopm: { proyecto_minero_id: @contactopm.proyecto_minero_id }
    assert_redirected_to contactopm_path(assigns(:contactopm))
  end

  test "should destroy contactopm" do
    assert_difference('Contactopm.count', -1) do
      delete :destroy, id: @contactopm
    end

    assert_redirected_to contactopms_path
  end
end
