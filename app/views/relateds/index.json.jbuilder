json.array!(@relateds) do |related|
  json.extract! related, :id, :family_id, :type_id, :relation
  json.url related_url(related, format: :json)
end
