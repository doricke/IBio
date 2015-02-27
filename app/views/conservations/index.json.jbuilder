json.array!(@conservations) do |conservation|
  json.extract! conservation, :id, :biosequence_id, :position, :level
  json.url conservation_url(conservation, format: :json)
end
