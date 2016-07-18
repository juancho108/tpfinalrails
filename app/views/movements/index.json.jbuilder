json.array!(@movements) do |movement|
  json.extract! movement, :id, :operacion, :tipo_operacion, :forma_de_pago, :persona, :monto_neto, :fecha_operacion, :detalles_adicionales
  json.url movement_url(movement, format: :json)
end
