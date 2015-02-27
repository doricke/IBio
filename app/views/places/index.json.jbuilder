json.array!(@places) do |place|
  json.extract! place, :id, :city, :state, :longitude, :latitude
  json.url place_url(place, format: :json)
end
