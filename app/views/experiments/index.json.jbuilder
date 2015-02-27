json.array!(@experiments) do |experiment|
  json.extract! experiment, :id, :instrument_id, :type_id, :note_id, :name, :created_at
  json.url experiment_url(experiment, format: :json)
end
