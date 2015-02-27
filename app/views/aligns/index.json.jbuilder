json.array!(@aligns) do |align|
  json.extract! align, :id, :msa_id, :biosequence_id, :align_rank, :updated_at, :align_sequence
  json.url align_url(align, format: :json)
end
