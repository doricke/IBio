json.array!(@data_ranges) do |data_range|
  json.extract! data_range, :id, :itype_id, :table_name, :lower, :upper, :qualifier, :description
  json.url data_range_url(data_range, format: :json)
end
