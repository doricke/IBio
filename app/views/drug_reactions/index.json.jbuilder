json.array!(@drug_reactions) do |drug_reaction|
  json.extract! drug_reaction, :id, :drug_id, :pathway_id, :reaction_id
  json.url drug_reaction_url(drug_reaction, format: :json)
end
