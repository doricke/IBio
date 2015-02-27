json.array!(@reactions) do |reaction|
  json.extract! reaction, :id, :pathway_id, :itype_id, :control_itype, :from, :to, :control
  json.url reaction_url(reaction, format: :json)
end
