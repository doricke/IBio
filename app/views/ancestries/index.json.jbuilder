json.array!(@ancestries) do |ancestry|
  json.extract! ancestry, :id, :ethnic_id, :percent
  json.url ancestry_url(ancestry, format: :json)
end
