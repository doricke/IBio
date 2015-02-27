json.array!(@locations) do |location|
  json.extract! location, :id, :activity_id, :latitude, :longitude, :bearing, :speed, :created_at
  json.url location_url(location, format: :json)
end
