json.extract! contrato, :id, :employee_id, :fecha_inicio, :fecha_fin, :fecha_suscripcion, :location_id, :division_id, :sueldo, :reingreso, :comments, :modalidad_id, :tipocontrato_id, :submodalidad_id, :moneda_id, :tiporemuneracion_id, :created_at, :updated_at
json.url contrato_url(contrato, format: :json)
