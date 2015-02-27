json.array!(@drug_genes) do |drug_gene|
  json.extract! drug_gene, :id, :drug_id, :gene_id, :cpic_dosing, :pharm_gbk_id
  json.url drug_gene_url(drug_gene, format: :json)
end
