json.array!(@alleles) do |allele|
  json.extract! allele, :id, :locus_id, :ethnic_id, :name, :seq, :regular_expression, :allele_frequency
  json.url allele_url(allele, format: :json)
end
