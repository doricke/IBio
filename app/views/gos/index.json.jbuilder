json.array!(@gos) do |go|
  json.extract! go, :id, :gene_id, :itype_id, :term, :pubmed
  json.url go_url(go, format: :json)
end
