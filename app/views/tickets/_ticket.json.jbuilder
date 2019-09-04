json.extract! ticket, :id, :fecha, :eess_id, :truck_id, :product_id, :quantity, :precioigv, :importe, :employee_id, :fecha_fact, :factura_id, :supplier_id, :card_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
