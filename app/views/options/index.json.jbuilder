json.array!(@configurations) do |configuration|
  json.extract! configuration, :id
  json.url configuration_url(configuration, format: :json)
end
