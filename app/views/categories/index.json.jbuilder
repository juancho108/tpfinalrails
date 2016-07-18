json.array!(@categories) do |category|
  json.extract! category, :id, :nombre
  json.url category_url(category, format: :json)
end
