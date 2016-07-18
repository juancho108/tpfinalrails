json.array!(@finances) do |finance|
  json.extract! finance, :id, :nombre, :dinero
  json.url finance_url(finance, format: :json)
end
