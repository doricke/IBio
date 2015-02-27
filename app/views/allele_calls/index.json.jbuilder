json.array!(@allele_calls) do |allele_call|
  json.extract! allele_call, :id, :locus_id, :experiment_id, :alleles
  json.url allele_call_url(allele_call, format: :json)
end
