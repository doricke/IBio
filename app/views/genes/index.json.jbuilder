json.array!(@genes) do |gene|
  json.extract! gene, :id, :note_id, :name, :ncbi_gene_id, :chromosome, :chromosome_start, :chromosome_end, :updated_at
  json.url gene_url(gene, format: :json)
end
