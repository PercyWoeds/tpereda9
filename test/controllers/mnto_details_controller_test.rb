require 'test_helper'

class MntoDetailsControllerTest < ActionController::TestCase
  setup do
    @mnto_detail = mnto_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mnto_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mnto_detail" do
    assert_difference('MntoDetail.count') do
      post :create, mnto_detail: { activity_id: @mnto_detail.activity_id, mnto_id: @mnto_detail.mnto_id, process: @mnto_detail.process }
    end

    assert_redirected_to mnto_detail_path(assigns(:mnto_detail))
  end

  test "should show mnto_detail" do
    get :show, id: @mnto_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mnto_detail
    assert_response :success
  end

  test "should update mnto_detail" do
    patch :update, id: @mnto_detail, mnto_detail: { activity_id: @mnto_detail.activity_id, mnto_id: @mnto_detail.mnto_id, process: @mnto_detail.process }
    assert_redirected_to mnto_detail_path(assigns(:mnto_detail))
  end

  test "should destroy mnto_detail" do
    assert_difference('MntoDetail.count', -1) do
      delete :destroy, id: @mnto_detail
    end

    assert_redirected_to mnto_details_path
  end
end
