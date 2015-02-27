json.array!(@activities) do |activity|
  json.extract! activity, :id, :type_id, :image_id, :attachment_id, :note_id, :activity_name, :start_time, :end_time, :intensity, :qualifier
  json.url activity_url(activity, format: :json)
end
