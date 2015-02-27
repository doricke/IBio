json.array!(@ethnics) do |ethnic|
  json.extract! ethnic, :id, :name, :race
  json.url ethnic_url(ethnic, format: :json)
end
