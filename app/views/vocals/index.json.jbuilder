json.array!(@vocals) do |vocal|
  json.extract! vocal, :id, :individual_id, :attachment_id, :speech_text, :start_time
  json.url vocal_url(vocal, format: :json)
end
