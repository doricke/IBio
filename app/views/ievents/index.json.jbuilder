json.array!(@ievents) do |event|
  json.extract! event, :id, :activity_id, :type_id, :name, :start_time, :end_time
  json.url event_url(event, format: :json)
end
