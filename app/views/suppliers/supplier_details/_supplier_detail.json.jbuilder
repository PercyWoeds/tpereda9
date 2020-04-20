json.extract! supplier_detail, :id, :name, :cargo, :telefono, :correo, :area, :supplier_id, :created_at, :updated_at
json.url supplier_detail_url(supplier_detail, format: :json)
