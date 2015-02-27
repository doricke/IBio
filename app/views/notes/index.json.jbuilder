json.array!(@notes) do |note|
  json.extract! note, :id, :comment
  json.url note_url(note, format: :json)
end
