require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @ticket = tickets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post :create, ticket: { card_id: @ticket.card_id, eess_id: @ticket.eess_id, employee_id: @ticket.employee_id, factura_id: @ticket.factura_id, fecha: @ticket.fecha, fecha_fact: @ticket.fecha_fact, importe: @ticket.importe, precioigv: @ticket.precioigv, product_id: @ticket.product_id, quantity: @ticket.quantity, supplier_id: @ticket.supplier_id, truck_id: @ticket.truck_id }
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should show ticket" do
    get :show, id: @ticket
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ticket
    assert_response :success
  end

  test "should update ticket" do
    patch :update, id: @ticket, ticket: { card_id: @ticket.card_id, eess_id: @ticket.eess_id, employee_id: @ticket.employee_id, factura_id: @ticket.factura_id, fecha: @ticket.fecha, fecha_fact: @ticket.fecha_fact, importe: @ticket.importe, precioigv: @ticket.precioigv, product_id: @ticket.product_id, quantity: @ticket.quantity, supplier_id: @ticket.supplier_id, truck_id: @ticket.truck_id }
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete :destroy, id: @ticket
    end

    assert_redirected_to tickets_path
  end
end
