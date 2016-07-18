json.array!(@pictures) do |picture|
  json.extract! picture, :id, :ruta
  json.url picture_url(picture, format: :json)
end
