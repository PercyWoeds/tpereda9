require 'test_helper'

class ContactopmdetailsControllerTest < ActionController::TestCase
  setup do
    @contactopmdetail = contactopmdetails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contactopmdetails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contactopmdetail" do
    assert_difference('Contactopmdetail.count') do
      post :create, contactopmdetail: { contacto: @contactopmdetail.contacto, contactopm_id: @contactopmdetail.contactopm_id, email: @contactopmdetail.email, telefono: @contactopmdetail.telefono }
    end

    assert_redirected_to contactopmdetail_path(assigns(:contactopmdetail))
  end

  test "should show contactopmdetail" do
    get :show, id: @contactopmdetail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contactopmdetail
    assert_response :success
  end

  test "should update contactopmdetail" do
    patch :update, id: @contactopmdetail, contactopmdetail: { contacto: @contactopmdetail.contacto, contactopm_id: @contactopmdetail.contactopm_id, email: @contactopmdetail.email, telefono: @contactopmdetail.telefono }
    assert_redirected_to contactopmdetail_path(assigns(:contactopmdetail))
  end

  test "should destroy contactopmdetail" do
    assert_difference('Contactopmdetail.count', -1) do
      delete :destroy, id: @contactopmdetail
    end

    assert_redirected_to contactopmdetails_path
  end
end
