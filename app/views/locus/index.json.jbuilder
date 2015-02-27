json.array!(@locus) do |locu|
  json.extract! locu, :id, :type_id, :name, :chromosome, :position
  json.url locu_url(locu, format: :json)
end
