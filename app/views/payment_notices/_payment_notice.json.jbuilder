json.extract! payment_notice, :id, :code, :employee_id, :asunto, :fecha, :concepto, :total, :processed, :date_processed, :created_at, :updated_at
json.url payment_notice_url(payment_notice, format: :json)
