json.array!(@papers) do |paper|
  json.extract! paper, :id, :pmid, :doi, :title, :authors, :reference
  json.url paper_url(paper, format: :json)
end
