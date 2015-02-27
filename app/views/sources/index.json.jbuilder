json.array!(@sources) do |source|
  json.extract! source, :id, :name, :updated_at
  json.url source_url(source, format: :json)
end
