require_relative 'node'

class Graph
  def initialize
    @node_set = Set.new
  end

  # @param [String] port_name
  def add_node(port_name)
    @node_set << Node.new(port_name)
  end

  # @param [String] first_port
  # @param [String] second_port
  # @param [Integer] distance
  def add_connection(first_port, second_port, distance)

  end

end