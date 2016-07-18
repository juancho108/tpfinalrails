json.array!(@records) do |record|
  json.extract! record, :id, :cuenta_ml, :estado, :orden
  json.url record_url(record, format: :json)
end
