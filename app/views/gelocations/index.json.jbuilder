json.array!(@gelocations) do |gelocation|
  json.extract! gelocation, :id, :logitude, :latitude, :timepoint
  json.url gelocation_url(gelocation, format: :json)
end
