json.array!(@effects) do |effect|
  json.extract! effect, :id, :biosequence_id, :variant_id, :name, :impact, :function_class, :codon_change, :aa_change
  json.url effect_url(effect, format: :json)
end
