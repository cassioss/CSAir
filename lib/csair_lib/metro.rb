# encoding: utf-8

class Metro

  attr_reader :name, :country, :continent

  def initialize(name, country, continent, timezone, population, coordinates, region)
    @name = name
    @country = country
    @continent = continent
    @timezone = timezone
    @coordinates = coordinates
    @population = population
    @region = region
  end

# Gets the airport timezone, having GMT as reference.
#
# @return [String]
  def timezone
    if @timezone >= 0
      'GMT +' + @timezone.to_s
    else
      'GMT ' + @timezone.to_s
    end
  end

# Gets the coordinates of the airport and adds degree symbols to it.
#
# @return [String]
  def coordinates
    coord_output = ''
    @coordinates.each do |direction, degrees|
      coord_output << degrees.to_s << '°' << direction << ', '
    end
    coord_output[0..-3]
  end

# Gets the population of the airport's city as a string.
#
# @return [String]
  def population
    @population.to_s
  end

# Gets the region of the airport using the code assigned to it.
#
# @return [String]
  def region
    case @code
      when 1 then 'Americas'
      when 2 then 'Africa'
      when 3 then 'Europe'
      else        'Asia and Oceania'
    end
  end

end