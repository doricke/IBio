json.array!(@algorithms) do |algorithm|
  json.extract! algorithm, :id, :algorithm_name, :version, :updated_at
  json.url algorithm_url(algorithm, format: :json)
end
