# coding: utf-8
require 'json'


class Reader

  INFTY = 1.0/0.0

  def initialize
    @json_graph_hash = graph_hash_from_json
  end

  def get_graph_hash
    @json_graph_hash['routes']
  end

  def get_city_info(city, info)
    found = false
    info_to_return = String.new
    @json_graph_hash['metros'].each do |city_info|
      if city_info['name'].casecmp(city)
        found = true
        info_to_return << get_specific_city_info(city_info, info)
      end
    end
    found ? info_to_return : 'The city you typed is not in our database.'
  end

  # @param [Hash] city_hash
  # @param [String] info
  # @return [String]
  def get_specific_city_info(city_hash, info)
    case info
      when 'code' || 'country' || 'continent' || 'population'
        city_hash[info]
      when 'timezone'
        if city_hash['timezone'] >= 0
          'GMT +' + city_hash[info].to_s
        else
          'GMT ' + city_hash[info].to_s
        end
      when 'coordinates'
        coord_string = String.new
        city_hash[info].each do |direction, degrees|
          coord_string << degrees.to_s << ' °' << direction << ' '
        end
        coord_string
      when 'region'
        get_region_from_number(city_hash[info])
      else get_closest_cities_to(city_hash['code'])
    end
  end

  # @param [Integer] num
  # @return [String]
  def get_region_from_number(num)
    case num
      when 1 then 'Americas'
      when 2 then 'Africa'
      when 3 then 'Europe'
      else 'Asia and Oceania'
    end
  end

  # @param [String] code
  # @return [String]
  def get_closest_cities_to(code)
    abc = Graph.new
  end

#  puts(json_file_hash['routes'][0]['ports'])

  # Reads all airport names inside the JSON file.
  # @return [SortedSet]
  def read_port_names
    port_names = Set.new
    @json_graph_hash['routes'].each do |route|
      port_names << route['ports'][0]
      port_names << route['ports'][1]
    end
    port_names
  end

  # Checks whether an airport name exists in the JSON file.
  # @param [String] airport
  def exists?(airport)
    read_port_names.include? airport
  end

  def city_exists?(city)
    found = false
    @json_graph_hash['metros'].each do |city_info|
      if city_info['name'].casecmp(city)
        found = true
      end
    end
    found
  end

  # @param [String] first_airport
  # @param [String] second_airport
  def evaluate_dist_value(first_airport, second_airport)
    dist_value = INFTY
    @json_graph_hash['routes'].each do |route|
      if route['ports'].include? first_airport and route['ports'].include? second_airport
        dist_value = route['distance']
      end
    end
    dist_value
  end

  # @param [String] first_airport
  # @param [String] second_airport
  def distance_between(first_airport, second_airport)
    if !exists?(first_airport) or !exists?(second_airport)
      -1
    elsif first_airport == second_airport
      0
    else
      evaluate_dist_value(first_airport, second_airport)
    end
  end

  # Reads a specific JSON file to obtain the graph data.
  def graph_hash_from_json
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', 'map_data.json')
    json_file = File.read(path_to_json)
    JSON.parse(json_file)
  end

end