# encoding: utf-8

# Class that keeps track of every specific information about an airport (or metro).
#
# @author Cassio dos Santos Sousa
# @version 1.1
# @since 1.0
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
      when 1 then
        'Americas'
      when 2 then
        'Africa'
      when 3 then
        'Europe'
      else
        'Asia and Oceania'
    end
  end

  # Changes a specific information about a city. It was considered, for this design, that any information
  # could change inside a Metro scope.
  #
  # @param [String] option determines which information is going to be changed.
  # @param [Integer, String, Hash] new_info the new information that replaces the original.
  #
  # @return [void]
  #
  def edit_information_about_city(option, new_info)
    case option
      when '1' then
        @name = new_info
      when '2' then
        @country = new_info
      when '3' then
        @continent = new_info
      when '4' then
        change_timezone_to(new_info)
      when '5' then
        change_coordinates_to(new_info)
      when '6' then
        change_population_to(new_info)
      when '7' then
        @region = new_info
      else # Do nothing
    end
  end

  private

  # @param [Integer] new_info
  # @return [void]
  #
  def change_timezone_to(new_info)
    raise TypeError, 'The new timezone is not an Integer value' unless new_info.is_a?(Integer)
    raise RangeError, 'New timezone over 12 hours of difference' unless new_info >= -12 and new_info <= 12
    @timezone = new_info
  end

  # @param [Hash] new_info
  # @return [void]
  #
  def change_coordinates_to(new_info)
    raise TypeError, 'The new coordinates do not make a Hash' unless new_info.is_a?(Hash)
    raise ArgumentError, 'There are not exactly two coordinates in the Hash' unless new_info.size == 2

    raise ArgumentError, 'First coordinate is not N or S' unless new_info.keys[0] == 'N' or new_info.keys[0] == 'S'
    raise ArgumentError, 'Second coordinate is not E or W' unless new_info.keys[1] == 'E' or new_info.keys[1] == 'W'

    raise RangeError, 'Latitude out of bounds (must be between 0 and 90 degrees)' unless new_info.values[0] >= 0 and new_info.values[0] <= 90
    raise RangeError, 'Longitude out of bounds (must be between 0 and 180 degrees)' unless new_info.values[1] >= 0 and new_info.values[1] <= 180

    @coordinates = new_info
  end

  # @param [Integer] new_info
  # @return [void]
  #
  def change_population_to(new_info)
    raise TypeError, 'The new population is not an Integer value' unless new_info.is_a?(Integer)
    raise RangeError, 'Negative value for population' unless new_info >= 0
    @population = new_info
  end

end