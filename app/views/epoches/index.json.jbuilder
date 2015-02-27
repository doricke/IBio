json.array!(@epoches) do |epoch|
  json.extract! epoch, :id, :year, :month, :day, :hour, :minute, :second, :usec
  json.url epoch_url(epoch, format: :json)
end
