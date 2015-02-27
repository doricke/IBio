json.array!(@drinks) do |drink|
  json.extract! drink, :id, :food_id, :unit_it, :amount, :consumed_at
  json.url drink_url(drink, format: :json)
end
