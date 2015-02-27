json.array!(@drugs) do |drug|
  json.extract! drug, :id, :note_id, :name
  json.url drug_url(drug, format: :json)
end
