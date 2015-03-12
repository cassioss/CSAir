# encoding: utf-8

# Class that keeps track of every specific information about an airport (or metro).
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class Metro

  attr_reader :name, :country, :continent

  # @param [String] name
  # @param [String] country
  # @param [String] continent
  # @param [Integer] timezone
  # @param [Integer] population
  # @param [Hash] coordinates
  # @param [Integer] region
  #
  # @return [void]
  #
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
  #
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
  #
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
  #
  def population
    @population.to_s
  end

  # Gets the region of the airport using the code assigned to it.
  #
  # @return [String]
  #
  def region
    case @region
      when 1 then 'Americas'
      when 2 then 'Africa'
      when 3 then 'Europe'
      else 'Asia and Oceania'
    end
  end

  # Changes a specific information about a city. Considering plausible changes, only two options are
  # valid and meaningful: timezone (if the city adopts daylight savings) and population.
  #
  # @param [String] option determines which information is going to be changed.
  # @param [Integer, String] new_info the new information that replaces the original.
  #
  # @return [void]
  #
  def edit_information_about_city(option, new_info)
    case option
      when '1' then @population = new_info
      when '2' then @timezone = new_info
      else # Do nothing
    end
  end

end