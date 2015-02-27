json.array!(@sleeps) do |sleep|
  json.extract! sleep, :id, :image_id, :start_time, :end_time, :asleep, :interruptions, :qualifier
  json.url sleep_url(sleep, format: :json)
end
