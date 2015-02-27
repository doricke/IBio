json.array!(@sick_symptoms) do |sick_symptom|
  json.extract! sick_symptom, :id, :sick_id, :symptom_id, :start_time, :end_time
  json.url sick_symptom_url(sick_symptom, format: :json)
end
