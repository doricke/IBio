json.array!(@images) do |image|
  json.extract! image, :id, :name, :created_at, :image_type, :image_blob
  json.url image_url(image, format: :json)
end
