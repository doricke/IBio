json.array!(@diseases) do |disease|
  json.extract! disease, :id, :note_id, :mim_id, :name
  json.url disease_url(disease, format: :json)
end
