json.array!(@biosequences) do |biosequence|
  json.extract! biosequence, :id, :source_id, :gene_id, :organism_id, :name, :copy_number, :exons, :aa_sequence, :mrna_sequence, :updated_at
  json.url biosequence_url(biosequence, format: :json)
end
