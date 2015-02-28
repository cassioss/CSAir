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

# Gets the code of the airport.
#
# @return [String]
  def get_code
    @code
  end

# Gets the city name of the airport.
#
# @return [String]
  def get_name
    @name
  end

# Gets the country of the airport.
#
# @return [String]
  def get_country
    @country
  end

# Gets the continent of the airport.
#
# @return [String]
  def get_continent
    @continent
  end

# Gets the airport timezone, having GMT as reference.
#
# @return [String]
  def get_timezone
    if @timezone >= 0
      'GMT +' + @timezone.to_s
    else
      'GMT ' + @timezone.to_s
    end
  end

# Gets the coordinates of the airport.
#
# @return [String]
  def get_coordinates
    coord_output = ''
    @coordinates.each do |direction, degrees|
      coord_output << degrees << '°' << direction << ', '
    end
    coord_output[0..-3]
  end

# Gets the population of the airport's city.
#
# @return [String]
  def get_population
    @population.to_s
  end

# Gets the region of the airport.
#
# @return [String]
  def get_region
    case @code
      when 1 then 'Americas'
      when 2 then 'Africa'
      when 3 then 'Europe'
      else        'Asia and Oceania'
    end
  end

end