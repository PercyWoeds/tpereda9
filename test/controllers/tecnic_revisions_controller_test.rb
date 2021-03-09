require 'test_helper'

class TecnicRevisionsControllerTest < ActionController::TestCase
  setup do
    @tecnic_revision = tecnic_revisions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tecnic_revisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tecnic_revision" do
    assert_difference('TecnicRevision.count') do
      post :create, tecnic_revision: { code: @tecnic_revision.code, name: @tecnic_revision.name }
    end

    assert_redirected_to tecnic_revision_path(assigns(:tecnic_revision))
  end

  test "should show tecnic_revision" do
    get :show, id: @tecnic_revision
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tecnic_revision
    assert_response :success
  end

  test "should update tecnic_revision" do
    patch :update, id: @tecnic_revision, tecnic_revision: { code: @tecnic_revision.code, name: @tecnic_revision.name }
    assert_redirected_to tecnic_revision_path(assigns(:tecnic_revision))
  end

  test "should destroy tecnic_revision" do
    assert_difference('TecnicRevision.count', -1) do
      delete :destroy, id: @tecnic_revision
    end

    assert_redirected_to tecnic_revisions_path
  end
end
