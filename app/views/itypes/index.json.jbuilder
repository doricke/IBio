json.array!(@types) do |type|
  json.extract! type, :id, :name, :category
  json.url type_url(type, format: :json)
end
