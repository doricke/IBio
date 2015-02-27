json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :type_id, :name, :content_type, :file_path, :created_at, :file_text, :file_binary
  json.url attachment_url(attachment, format: :json)
end
