json.extract! paymentnotice_detail, :id, :fecha_inicio, :fecha_culmina, :total, :descrip, :lugar, :price_unit, :sub_total, :igv, :total, :nro_compro, :nro_documento, :observa, :payment_notices_id, :created_at, :updated_at
json.url paymentnotice_detail_url(paymentnotice_detail, format: :json)
