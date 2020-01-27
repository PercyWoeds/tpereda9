json.extract! products_line, :id, :code, :name, :user_id, :created_at, :updated_at
json.url products_line_url(products_line, format: :json)
