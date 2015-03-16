require 'json'

# Module that writes and merges hashed data in a JSON file.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class Writer

  #
  # @return [void]
  #
  def initialize
    merge('map_data.json', 'cmi_hub.json')
  end

  # @param [String] json_filename1
  # @param [String] json_filename2
  #
  # @return [void]
  #
  def merge(json_filename1, json_filename2)

    hash1 = JSON.parse(get_file(json_filename1))
    hash2 = JSON.parse(get_file(json_filename2))

    merged_hash = Hash.new

    hash1.each do |key1, value1|
      hash2.each do |key2, value2|
        if key1 == key2
          merged_values = value1 + value2
          merged_hash[key1] = merged_values.uniq
        end
      end
    end

    save_file(merged_hash, 'merged_map_data.json')

  end

  # @param [Hash] json_hash
  # @param [String] filename
  #
  # @return [void]
  #
  def save_file(json_hash, filename)
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', filename)
    File.open(path_to_json, 'w') do |file|
      file.write(json_hash.to_json)
    end
  end

  # @param [String] filename
  #
  # @return [File]
  #
  def get_file(filename)
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', filename)
    File.read(path_to_json)
  end

end