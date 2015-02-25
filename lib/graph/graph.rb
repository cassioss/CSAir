require 'json'

module Graph

  def self.json_file_hash
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', 'map_data.json')
    json_file = File.read(path_to_json)
    json_parsed_hash = JSON.parse(json_file)
    return json_parsed_hash
  end

  puts(json_file_hash['routes'][0]['ports'])

  def self.distance_between(first_airport, second_airport)
    dist_value = 1.0/0.0
    json_file_hash['routes'].each do |route|
      puts route
    end
=begin
    (first_airport.equal? second_airport) ?
        dist_value = 0 :
        json_file_hash['routes'].each  { |route| if route }

    return dist_value
    end
=end
  end

  distance_between('a','b')
end