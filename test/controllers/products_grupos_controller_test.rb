require 'test_helper'

class ProductsGruposControllerTest < ActionController::TestCase
  setup do
    @products_grupo = products_grupos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products_grupos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create products_grupo" do
    assert_difference('ProductsGrupo.count') do
      post :create, products_grupo: { code: @products_grupo.code, name: @products_grupo.name, user_id: @products_grupo.user_id }
    end

    assert_redirected_to products_grupo_path(assigns(:products_grupo))
  end

  test "should show products_grupo" do
    get :show, id: @products_grupo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @products_grupo
    assert_response :success
  end

  test "should update products_grupo" do
    patch :update, id: @products_grupo, products_grupo: { code: @products_grupo.code, name: @products_grupo.name, user_id: @products_grupo.user_id }
    assert_redirected_to products_grupo_path(assigns(:products_grupo))
  end

  test "should destroy products_grupo" do
    assert_difference('ProductsGrupo.count', -1) do
      delete :destroy, id: @products_grupo
    end

    assert_redirected_to products_grupos_path
  end
end
