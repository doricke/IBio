json.array!(@sicks) do |sick|
  json.extract! sick, :id, :type_id, :start_time, :end_time
  json.url sick_url(sick, format: :json)
end
