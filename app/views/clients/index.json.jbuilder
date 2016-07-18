json.array!(@clients) do |client|
  json.extract! client, :id, :nombre, :mail, :detalle_adicional
  json.url client_url(client, format: :json)
end
