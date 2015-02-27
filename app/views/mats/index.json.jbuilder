json.array!(@mats) do |mat|
  json.extract! mat, :id, :individual_id, :vocal_id, :attachment_id, :algorithm_id, :score, :start_time, :updated_at
  json.url mat_url(mat, format: :json)
end
