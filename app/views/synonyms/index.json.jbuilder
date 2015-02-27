json.array!(@synonyms) do |synonym|
  json.extract! synonym, :id, :itype_id, :source_id, :synonym_name, :table_name
  json.url synonym_url(synonym, format: :json)
end
