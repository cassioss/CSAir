require_relative '../../lib/csair_lib/graph'
require_relative '../../lib/csair_lib/dictionary'
require_relative '../../lib/csair_lib/metro'

# Class that aggregates all possible queries the user might want to make.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class Query

# Constructor that initializes the JSON graph and a dictionary to decode the name of a city to its airport code,
# and vice-versa.
#
# @return [void]
#
  def initialize
    @json_graph = Graph.new
    @json_graph.create_graph_from_json
    @dict = Dictionary.new
  end

#
# Prints all the cities in the CSAir network.
#
# @return [void]
#
  def list_all_cities
    alpha_order = SortedSet.new
    @dict.metros.values.each do |airport|
      alpha_order.add(airport.name)
    end
    alpha_order.each do |name|
      puts name
    end
  end

# Gets an specific information about a city according to the option entered by a user. Aside from airport code
# (obtained from a Dictionary object) and the closest cities (obtained from a Graph object), the options return an
# information from a Metro object related to the city.
#
# @param [String] city The city name.
#
# @param [String] num The option number, treated as a String.
#
# @return [void]
#
  def get_information_from(city, num)
    code = @dict.encode(city)
    case num
      when '1' then code
      when '2' then @dict.metros[code].country
      when '3' then @dict.metros[code].continent
      when '4' then @dict.metros[code].timezone
      when '5' then @dict.metros[code].coordinates
      when '6' then @dict.metros[code].population
      when '7' then @dict.metros[code].region
      else get_closest_cities_to(code)
    end
  end

# Given an airport code, returns a string that contains the city name followed be city code in parenthesis, a
# common format used to associate cities to airports in search engines.
#
# @param [String] port_code An airport code.
#
# @return [String] The corresponding city name followed by the airport code in parenthesis.
#
  def city_plus_code(port_code)
    @dict.unlock(port_code) + ' (' + port_code + ')'
  end

# Prints all airports that are connected to a city by one CSAir flight.
#
# @param [String] city_code The airport code.
#
# @return [void]
#
  def get_closest_cities_to(city_code)
    @json_graph.get_closest_cities(city_code).each do |port_code, distance|
      print "\n#{city_plus_code(port_code)} - #{distance.to_s} miles"
    end
    print "\n"
  end


# Prints the longest flight of the network, in miles.
#
# @return [void]
#
  def get_longest_flight
    port_1 = String.new
    port_2 = String.new
    ref_distance = 0
    @json_graph.node_hash.each do |first_port, connections|
      connections.each do |second_port, distance|
        if distance > ref_distance
          port_1 = first_port
          port_2 = second_port
          ref_distance = distance
        end
      end
    end
    puts 'Longest flight: ' + city_plus_code(port_1) + ' - ' + city_plus_code(port_2) + ': ' + ref_distance.to_s +
             ' miles'
  end

# Prints the shortest flight of the network, in miles.
#
# @return [void]
#
  def get_shortest_flight
    port_1 = String.new
    port_2 = String.new
    ref_distance = 40000
    @json_graph.node_hash.each do |first_port, connections|
      connections.each do |second_port, distance|
        if distance < ref_distance
          port_1 = first_port
          port_2 = second_port
          ref_distance = distance
        end
      end
    end
    puts 'Shortest flight: ' + city_plus_code(port_1) + ' - ' + city_plus_code(port_2) + ': ' + ref_distance.to_s +
             ' miles'
  end

# Prints the average flight distance for an CSAir flight, in miles.
#
# @return [void]
#
  def get_average_distance
    flight_counter = @json_graph.num_of_flights
    total_distance = @json_graph.total_distance
    puts 'Average flight distance: ' + ((1.0) * total_distance / flight_counter).to_i.to_s + ' miles'
  end

# Prints the biggest city that allocates CSAir flights, in terms of population.
#
# @return [void]
#
  def get_biggest_city
    city_port = String.new
    ref_population = 0
    @dict.metros.each do |port, metro|
      if metro.population.to_i > ref_population
        city_port = port
        ref_population = metro.population.to_i
      end
    end
    puts 'Biggest city: ' + city_plus_code(city_port) + ': ' + ref_population.to_s + ' inhabitants'
  end

# Prints the smallest city that allocates CSAir flights, in terms of population.
#
# @return [void]
#
  def get_smallest_city
    city_port = String.new
    ref_population = 7000000
    @dict.metros.each do |port, metro|
      if metro.population.to_i < ref_population
        city_port = port
        ref_population = metro.population.to_i
      end
    end
    puts 'Smallest city: ' + city_plus_code(city_port) + ': ' + ref_population.to_s + ' inhabitants'
  end

# Prints the average city size for a city that allocates CSAir flight, in terms of population.
#
# @return [void]
#
  def get_average_city_size
    city_counter = 0
    total_population = 0
    @dict.metros.values.each do |metro|
      total_population += metro.population.to_i
      city_counter += 1
    end
    puts 'Average population of CSAir cities: ' + ((1.0) * total_population / city_counter).to_i.to_s + ' inhabitants'
  end

# Prints the continents that have CSAir flights, along with the cities that allocate them.
#
# @return [void] calls print_hash(city_hash)
#
  def get_continents
    city_hash = Hash.new
    @dict.metros.values.each do |metro|
      if city_hash[metro.continent].nil?
        city_hash[metro.continent] = SortedSet.new
      end
      city_hash[metro.continent].add(metro.name)
    end
    print_hash(city_hash)
  end

# @return [void]
#
  def print_hash(city_hash)
    print "\nCSAir cities in each continent"
    city_hash.each do |continent, port_set|
      print "\n\n#{continent}:\n"
      port_set.each do |port_name|
        print "\n#{port_name}"
      end
    end
    print "\n"
  end

# @return [Integer]
#
  def get_most_connections
    reference = 0
    @json_graph.node_hash.values.each do |port_hash|
      if port_hash.size > reference
        reference = port_hash.length
      end
    end
    reference
  end

# @return [void]
#
  def get_hub_cities
    reference = get_most_connections
    print "\n\nCities with most CSAir connections (" + reference.to_s + "):\n"
    @json_graph.node_hash.each do |port, port_hash|
      if port_hash.length == reference
        puts city_plus_code(port)
      end
    end
  end

# @return [String]
#
  def get_popup_url
    'http://www.gcmap.com/mapui?P=' + @json_graph.get_url_addition
  end

# @param [String] name
#
# @return [String]
#
  def get_code(name)
    @dict.encode(name)
  end

end