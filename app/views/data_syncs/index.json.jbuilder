json.array!(@data_syncs) do |data_sync|
  json.extract! data_sync, :id, :individual_id, :instrument_id, :algorithm_id, :updated_at
  json.url data_sync_url(data_sync, format: :json)
end
