json.array!(@attributes) do |attribute|
  json.extract! attribute, :id, :unit_id, :name, :category, :amount, :measured_at
  json.url attribute_url(attribute, format: :json)
end
