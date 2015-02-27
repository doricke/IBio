json.array!(@solvents) do |solvent|
  json.extract! solvent, :id, :biosequence_id, :position, :accessibility
  json.url solvent_url(solvent, format: :json)
end
