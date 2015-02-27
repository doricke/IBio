json.array!(@structures) do |structure|
  json.extract! structure, :id, :name, :pdb_length, :pdb
  json.url structure_url(structure, format: :json)
end
