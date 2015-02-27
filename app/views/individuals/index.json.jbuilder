json.array!(@individuals) do |individual|
  json.extract! individual, :id, :sex, :code_name, :is_public
  json.url individual_url(individual, format: :json)
end
