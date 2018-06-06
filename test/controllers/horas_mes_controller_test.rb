require 'test_helper'

class HorasMesControllerTest < ActionController::TestCase
  setup do
    @horas_me = horas_mes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:horas_mes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create horas_me" do
    assert_difference('HorasMe.count') do
      post :create, horas_me: { dm: @horas_me.dm, dt: @horas_me.dt, employee_id: @horas_me.employee_id, fal: @horas_me.fal, pat: @horas_me.pat, payroll_id: @horas_me.payroll_id, sub: @horas_me.sub, tot: @horas_me.tot, vac: @horas_me.vac }
    end

    assert_redirected_to horas_me_path(assigns(:horas_me))
  end

  test "should show horas_me" do
    get :show, id: @horas_me
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @horas_me
    assert_response :success
  end

  test "should update horas_me" do
    patch :update, id: @horas_me, horas_me: { dm: @horas_me.dm, dt: @horas_me.dt, employee_id: @horas_me.employee_id, fal: @horas_me.fal, pat: @horas_me.pat, payroll_id: @horas_me.payroll_id, sub: @horas_me.sub, tot: @horas_me.tot, vac: @horas_me.vac }
    assert_redirected_to horas_me_path(assigns(:horas_me))
  end

  test "should destroy horas_me" do
    assert_difference('HorasMe.count', -1) do
      delete :destroy, id: @horas_me
    end

    assert_redirected_to horas_mes_path
  end
end
