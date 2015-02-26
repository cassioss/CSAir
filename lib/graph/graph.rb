class Graph
  INFTY = 1.0/0.0

  def initialize
    @node_hash = Hash.new
  end

  def to_s
    graph_string = ''
    add_comma1 = false
    @node_hash.each do |node, node_hash|
      add_comma2 = false
      if add_comma1
        graph_string << ' || '
      else
        add_comma1 = true
      end
      graph_string << "{#{node}"
      unless node_hash.empty?
        graph_string << ' =>'
        node_hash.each do |port, dist|
          if add_comma2
            graph_string << ', '
          else
            add_comma2 = true
          end
          graph_string << " {#{port}: #{dist}}"
        end
      end
      graph_string << '}'
    end
    graph_string
  end

  # Adds a connection between two nodes in the graph, creating them if necessary.
  #
  # @param [String] first_port
  # @param [String] second_port
  # @param [Integer] distance
  def add_connection(first_port, second_port, distance)
    add_if_non_existing(first_port)
    add_if_non_existing(second_port)
    @node_hash[first_port][second_port] = distance
    @node_hash[second_port][first_port] = distance
  end

  # Gets the value of a connection (or route) between two nodes (or airports).
  #
  # @param [String] first_port
  # @param [String] second_port
  # @return [Integer]
  def get_connection(first_port, second_port)
    case
      when one_does_not_exist(first_port, second_port) then -1
      when first_port == second_port then 0
      else @node_hash[first_port][second_port]
    end
  end

  # Adds a note to the graph without connection. The distance to any other node is infinite.
  #
  # @param [String] port_name
  def add_node(port_name)
    @node_hash[port_name] = Hash.new(INFTY)
  end

  private

  # Checks if at least one of the nodes does not exist in the graph.
  #
  # @param [String] first_port
  # @param [String] second_port
  def one_does_not_exist(first_port, second_port)
    !@node_hash.include? first_port or !@node_hash.include? second_port
  end

  # Adds a node to the graph if it does not exist yet.
  #
  # @param [String] port
  def add_if_non_existing(port)
    unless @node_hash.include? port
      add_node(port)
    end
  end

end