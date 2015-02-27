json.array!(@variants) do |variant|
  json.extract! variant, :id, :biosequence_id, :disease_id, :sequence_type, :mutation, :mutation_type, :sequence_start, :sequence_end
  json.url variant_url(variant, format: :json)
end
