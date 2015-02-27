json.array!(@organisms) do |organism|
  json.extract! organism, :id, :name, :taxonomy
  json.url organism_url(organism, format: :json)
end
