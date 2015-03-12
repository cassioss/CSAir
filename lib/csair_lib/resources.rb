require_relative 'reader'

# Class that keeps track of the sources that contain CSAir's information.
#
# @author Cassio dos Santos Sousa
# @version 1.1
# @since 1.0
#
class Resources

  attr_reader :sources

  # @param [String] json_file_name
  #
  # @return [void]
  #
  def initialize(json_file_name)
    @sources = get_sources_from_json(json_file_name)
  end

  # @param [String] json_file_name
  #
  # @return [void]
  #
  def get_sources_from_json(json_file_name)
    read_me = Reader.new(json_file_name)
    read_me.get_data_sources
  end

end