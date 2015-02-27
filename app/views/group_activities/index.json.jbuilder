json.array!(@group_activities) do |group_activity|
  json.extract! group_activity, :id, :group_id, :activity_id
  json.url group_activity_url(group_activity, format: :json)
end
