json.array!(@panels) do |panel|
  json.extract! panel, :id, :attachment_id, :type_id, :start_time, :end_time
  json.url panel_url(panel, format: :json)
end
