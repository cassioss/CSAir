require_relative 'reader'

class Resources

  attr_reader :sources

  def initialize
    @sources = get_sources_from_json
  end

  def get_sources_from_json
    read_me = Reader.new
    read_me.get_data_sources
  end

end