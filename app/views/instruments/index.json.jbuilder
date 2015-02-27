json.array!(@instruments) do |instrument|
  json.extract! instrument, :id, :name, :instrument_type
  json.url instrument_url(instrument, format: :json)
end
