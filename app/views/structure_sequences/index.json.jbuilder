json.array!(@structure_sequences) do |structure_sequence|
  json.extract! structure_sequence, :id, :structure_id, :biosequence_id, :chain
  json.url structure_sequence_url(structure_sequence, format: :json)
end
