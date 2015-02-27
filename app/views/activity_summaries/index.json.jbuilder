json.array!(@activity_summaries) do |activity_summary|
  json.extract! activity_summary, :id, :image_id, :type_id, :name, :qualifier, :amount, :start_time, :end_time
  json.url activity_summary_url(activity_summary, format: :json)
end
