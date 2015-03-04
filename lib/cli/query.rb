require_relative '../../lib/csair_lib/graph'
require_relative '../../lib/csair_lib/dictionary'
require_relative '../../lib/csair_lib/metro'

class Query

  def initialize
    @json_graph = Graph.new
    @dict = Dictionary.new
  end

  def list_all_cities
    alpha_order = SortedSet.new
    @dict.metros.each do |key, airport|
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
  def get_closest_cities_to(city_code)
    @json_graph.get_closest_cities(city_code).each do |port_code, distance|
      print "\n#{city_plus_code(port_code)} - #{distance.to_s} miles"
    end
    print "\n"
  end

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

  def get_average_distance
    flight_counter = 0
    total_distance = 0
    @json_graph.node_hash.each do |key, connections|
      connections.each do |port_key, distance|
        total_distance += distance
        flight_counter += 1
      end
    end
    puts 'Average flight distance: ' + ((1.0) * total_distance / flight_counter).to_i.to_s + ' miles'
  end

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

  def get_average_city_size
    city_counter = 0
    total_population = 0
    @dict.metros.each do |key, metro|
      total_population += metro.population.to_i
      city_counter += 1
    end
    puts 'Average population of CSAir cities: ' + ((1.0) * total_population / city_counter).to_i.to_s + ' inhabitants'
  end

  def get_continents
    city_hash = Hash.new()
    @dict.metros.each do |key, metro|
      if city_hash[metro.continent].nil?
        city_hash[metro.continent] = SortedSet.new
      end
      city_hash[metro.continent].add(metro.name)
    end
    print_hash(city_hash)
  end

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

  def get_most_connections
    reference = 0
    @json_graph.node_hash.each do |key, port_hash|
      if port_hash.size > reference
        reference = port_hash.length
      end
    end
    reference
  end

  def get_hub_cities
    reference = get_most_connections
    print "\n\nCities with most CSAir connections (" + reference.to_s + "):\n"
    @json_graph.node_hash.each do |port, port_hash|
      if port_hash.length == reference
        puts city_plus_code(port)
      end
    end
  end

  def get_popup_url
    'http://www.gcmap.com/mapui?P=' + @json_graph.get_url_addition
  end

  def get_code(name)
    @dict.encode(name)
  end

end