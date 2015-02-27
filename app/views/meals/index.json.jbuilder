json.array!(@meals) do |meal|
  json.extract! meal, :id, :consumed_at
  json.url meal_url(meal, format: :json)
end
