json.array!(@gene_reactions) do |gene_reaction|
  json.extract! gene_reaction, :id, :pathway_id, :reaction_id, :gene_id, :role_itype_id
  json.url gene_reaction_url(gene_reaction, format: :json)
end
