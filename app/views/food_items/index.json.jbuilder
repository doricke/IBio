json.array!(@food_items) do |food_item|
  json.extract! food_item, :id, :meal_id, :food_id, :unit_id, :amount, :calories
  json.url food_item_url(food_item, format: :json)
end
