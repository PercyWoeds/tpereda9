json.extract! service, :id, :code, :name, :cost, :price, :tax1_name, :tax1, :quantity, :description, :comments, :company_id, :discount, :currtotal, :created_at, :updated_at
json.url service_url(service, format: :json)