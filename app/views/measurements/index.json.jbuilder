json.array!(@measurements) do |measurement|
  json.extract! measurement, :id, :type_id, :name, :unit_id, :normal_id, :note_id, :created_at, :result
  json.url measurement_url(measurement, format: :json)
end
