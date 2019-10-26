json.extract! cotizacion, :id, :fecha, :code, :customer_id, :punto_id, :punto2_id, :tipocargue_id, :tarifa, :processed, :comments, :created_at, :updated_at
json.url cotizacion_url(cotizacion, format: :json)
