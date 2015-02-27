json.array!(@disease_genes) do |disease_gene|
  json.extract! disease_gene, :id, :disease_id, :gene_id
  json.url disease_gene_url(disease_gene, format: :json)
end
