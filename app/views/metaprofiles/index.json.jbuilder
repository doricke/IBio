json.array!(@metaprofiles) do |metaprofile|
  json.extract! metaprofile, :id, :organism_id, :count, :measured_at
  json.url metaprofile_url(metaprofile, format: :json)
end
