json.array!(@copies) do |copy|
  json.extract! copy, :id, :lugar, :precio_compra, :packaging, :estado_del_producto, :estado, :nro_serie, :descripcion
  json.url copy_url(copy, format: :json)
end
