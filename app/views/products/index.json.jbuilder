json.array!(@products) do |product|
  json.extract! product, :id, :nombre, :tipo_stock, :instruccion_general
  json.url product_url(product, format: :json)
end
