# encoding: utf-8

class Metro
  def initialize(code, name, country, continent, timezone, population, coordinates, region)
    @code = code
    @name = name
    @country = country
    @continent = continent
    @timezone = timezone
    @coordinates = coordinates
    @population = population
    @region = region
  end

# Returns an airport timezone.
  def get_timezone
    if @timezone >= 0
      'GMT +' + @timezone.to_s
    else
      'GMT ' + @timezone.to_s
    end
  end

# Returns the coordinates of an airport.
  def get_coordinates
    coord_output = ''
    @coordinates.each do |direction, degrees|
      coord_output << degrees << '°' << direction << ', '
    end
    coord_output[0..-3]
  end
end