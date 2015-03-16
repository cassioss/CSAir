require_relative 'graph/graph'
require_relative 'dictionary'
require_relative 'resources'
require_relative 'metro/all_metros'


class ResultJSON

  #
  # @return [void]
  #
  def initialize(json_file_name)
    @reader = Reader.new(json_file_name)
    @resources = @reader.get_data_sources
    @graph = @reader.get_graph_hash
    @dictionary = Dictionary.new
    @metros = AllMetros.new
  end

end