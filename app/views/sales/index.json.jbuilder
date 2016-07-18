json.array!(@sales) do |sale|
  json.extract! sale, :id, :precio_bruto, :precio_neto, :forma_de_pago, :quien_cargo, :ganancia
  json.url sale_url(sale, format: :json)
end
