json.array!(@monitor_data) do |monitor_datum|
  json.extract! monitor_datum, :id, :instrument_id, :individual_id, :attachment_id, :image_id, :itype_id, :start_time, :end_time, :points_per_second, :points_per_hour, :data_vector
  json.url monitor_datum_url(monitor_datum, format: :json)
end
