require 'json'

module Graph

  def self.json_file_hash
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', 'map_data.json')
    json_file = File.read(path_to_json)
    json_parsed_hash = JSON.parse(json_file)
    return json_parsed_hash
  end

#  puts(json_file_hash['routes'][0]['ports'])

  # @param [String] first_airport
  # @param [String] second_airport
  def self.distance_between(first_airport, second_airport)
    if first_airport == second_airport
      return 0
    else
      dist_value = 1.0/0.0
      json_file_hash['routes'].each do |route|
        if route['ports'].include? first_airport and route['ports'].include? second_airport
          dist_value = route['distance']
        end
      end
      return dist_value
    end
  end

  puts distance_between('LIM','LIM')
end