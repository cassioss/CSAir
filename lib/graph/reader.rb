require 'json'

module Reader

  INFTY = 1.0/0.0

  # Reads a specific JSON file to obtain the graph data.
  # @return [Hash] json_parsed_hash
  def self.json_file_hash
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', 'map_data.json')
    json_file = File.read(path_to_json)
    json_parsed_hash = JSON.parse(json_file)
    return json_parsed_hash
  end

#  puts(json_file_hash['routes'][0]['ports'])

  # Reads all airport names inside the JSON file.
  # @return [SortedSet]
  def self.read_port_names
    port_names = Set.new
    json_file_hash['routes'].each do |route|
      port_names << route['ports'][0]
      port_names << route['ports'][1]
    end
    return port_names
  end

  # Checks whether an airport name exists in the JSON file.
  # @param [String] airport
  def self.exists?(airport)
    return read_port_names.include? airport
  end

  # @param [String] first_airport
  # @param [String] second_airport
  def self.evaluate_dist_value(first_airport, second_airport)
    dist_value = INFTY
    json_file_hash['routes'].each do |route|
      if route['ports'].include? first_airport and route['ports'].include? second_airport
        dist_value = route['distance']
      end
    end
    return dist_value
  end

  # @param [String] first_airport
  # @param [String] second_airport
  def self.distance_between(first_airport, second_airport)
    if !exists?(first_airport) or !exists?(second_airport)
      return -1
    elsif first_airport == second_airport
      return 0
    else
      evaluate_dist_value(first_airport, second_airport)
    end
  end

end