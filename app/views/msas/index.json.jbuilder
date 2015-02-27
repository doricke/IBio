json.array!(@msas) do |msa|
  json.extract! msa, :id, :gene_id, :name, :category, :description, :msa_type, :updated_at
  json.url msa_url(msa, format: :json)
end
