json.array!(@normals) do |normal|
  json.extract! normal, :id, :ethnic_id, :note_id, :normal_low, :normal_high, :ref_range, :sex, :age_low, :age_high
  json.url normal_url(normal, format: :json)
end
