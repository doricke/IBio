json.array!(@prescriptions) do |prescription|
  json.extract! prescription, :id, :drug_id, :unit_it, :dose, :daily, :start_time, :end_time
  json.url prescription_url(prescription, format: :json)
end
