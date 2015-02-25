module Graph

  def self.json_file_hash
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', 'resources', 'map_data.json')
    json_file = File.read(path_to_json)
    json_parsed_hash = JSON.parse(json_file)
    return json_parsed_hash
  end

  puts(json_file_hash)

end