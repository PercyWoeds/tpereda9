require 'test_helper'

class AntecedentsControllerTest < ActionController::TestCase
  setup do
    @antecedent = antecedents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:antecedents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create antecedent" do
    assert_difference('Antecedent.count') do
      post :create, antecedent: { code: @antecedent.code, name: @antecedent.name }
    end

    assert_redirected_to antecedent_path(assigns(:antecedent))
  end

  test "should show antecedent" do
    get :show, id: @antecedent
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @antecedent
    assert_response :success
  end

  test "should update antecedent" do
    patch :update, id: @antecedent, antecedent: { code: @antecedent.code, name: @antecedent.name }
    assert_redirected_to antecedent_path(assigns(:antecedent))
  end

  test "should destroy antecedent" do
    assert_difference('Antecedent.count', -1) do
      delete :destroy, id: @antecedent
    end

    assert_redirected_to antecedents_path
  end
end
