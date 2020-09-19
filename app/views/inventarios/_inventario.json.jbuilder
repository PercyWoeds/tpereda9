json.extract! inventario, :id, :almacen_id, :fecha, :descripcion, :tipo, :total, :created_at, :updated_at
json.url inventario_url(inventario, format: :json)
