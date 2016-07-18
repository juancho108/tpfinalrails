json.array!(@origin_sales) do |origin_sale|
  json.extract! origin_sale, :id, :nombre, :monto_bruto, :monto_neto
  json.url origin_sale_url(origin_sale, format: :json)
end
