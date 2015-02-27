json.array!(@biosequence_domains) do |biosequence_domain|
  json.extract! biosequence_domain, :id, :biosequence_id, :domain_id, :seq_start, :seq_end
  json.url biosequence_domain_url(biosequence_domain, format: :json)
end
