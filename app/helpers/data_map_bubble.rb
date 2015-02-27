class DataMapBubble
  attr_reader :id_code
  attr_reader :radius
  attr_reader :likelihood
  attr_reader :name
  attr_reader :fillKey
  attr_reader :latitude
  attr_reader :longitude

  def initialize(id_code, radius, likelihood, name, fillKey, latitude, longitude)
    @id_code, @radius, @likelihood, @name, @fillKey, @latitude, @longitude = id_code, radius, likelihood, name, fillKey, latitude, longitude
  end
end
