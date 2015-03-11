require_relative 'reader'

# Class that keeps track of the sources that contain CSAir's information.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class Resources

  attr_reader :sources

  #
  # @return [void]
  #
  def initialize
    @sources = get_sources_from_json
  end

  #
  # @return [void]
  #
  def get_sources_from_json
    read_me = Reader.new
    read_me.get_data_sources
  end

end