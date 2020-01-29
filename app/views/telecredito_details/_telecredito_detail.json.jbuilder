json.extract! telecredito_detail, :id, :fecha, :nro, :operacion, :purchase_id, :beneficiario, :documento, :moneda, :importe, :egreso, :aprueba, :observacion, :telecredito_id, :created_at, :updated_at
json.url telecredito_detail_url(telecredito_detail, format: :json)
