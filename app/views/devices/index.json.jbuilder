json.array!(@devices) do |device|
  json.extract! device, :id, :individual_id, :instrument_id, :wear_at, :serial_no
  json.url device_url(device, format: :json)
end
