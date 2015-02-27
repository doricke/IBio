json.array!(@airs) do |air|
  json.extract! air, :id, :itype_id, :place_id, :air_value, :sampled_at
  json.url air_url(air, format: :json)
end
