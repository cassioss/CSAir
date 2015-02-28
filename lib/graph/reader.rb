# coding: utf-8
require 'json'


class Reader

  INFTY = 1.0/0.0

  def initialize
    @json_data_hash = data_hash_from_json
  end

  def get_graph_hash
    @json_data_hash['routes']
  end

  def get_metro_hash
    @json_data_hash['metros']
  end

  private

  # Reads a specific JSON file to obtain the graph data.
  def data_hash_from_json
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', 'map_data.json')
    json_file = File.read(path_to_json)
    JSON.parse(json_file)
  end

end