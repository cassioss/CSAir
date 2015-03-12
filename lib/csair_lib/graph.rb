require_relative 'reader'
require_relative 'connection'

# Class created to handle graph creation and reading for the CSAir flight network.
#
# @author Cassio dos Santos Sousa
# @version 1.1
# @since 1.0
#
class Graph

  attr_reader :node_hash, :total_distance, :num_of_flights, :shortest_flight, :longest_flight

  # Reference value for infinity.
  INFTY = 1.0/0.0

  # Initializes each one of the components that are useful for a Graph object.
  #
  # @return [void]
  #
  def initialize
    @node_hash = Hash.new
    @connectors = Connection.new
    @total_distance = 0
    @num_of_flights = 0
    @shortest_flight = {:distance => INFTY, :ports => []}
    @longest_flight = {:distance => 0, :ports => []}
  end

  # Gets a string with appropriate formatting for a graph.
  #
  # @return [String] A string whose lines contain one of the nodes (airport codes) and its connections.
  #
  def to_s
    graph_string = '{Graph}'
    @node_hash.each { |node, node_hash| graph_string << get_node_connections(node, node_hash) }
    graph_string
  end

  # Adds a connection between two nodes in the graph, creating them if necessary.
  #
  # @param [String] first_port The first airport code
  # @param [String] second_port The second airport code
  # @param [Integer] distance The distance between the airports (by flight) in miles.
  #
  # @return [void]
  #
  def add_connection(first_port, second_port, distance)
    add_if_non_existing(first_port)
    add_if_non_existing(second_port)
    @connectors.add_connection(first_port, second_port)
    @node_hash[first_port][second_port] = @node_hash[second_port][first_port] = distance
    make_statistics(first_port, second_port, distance)
  end

  # @param [String] first_port
  # @param [String] second_port
  # @param [Integer] distance
  #
  # @return [void]
  #
  def make_statistics(first_port, second_port, distance)
    @total_distance += distance
    @num_of_flights += 1
    account_for_shortest_flight(first_port, second_port, distance)
    account_for_longest_flight(first_port, second_port, distance)
  end

  # Gets the value of a connection (or route) between two nodes (or airports).
  #
  # ## Edge cases
  #
  # * The airports are equal: returns 0;
  # * One of the airports does not exist: returns -1 (does not break Dijkstra's algorithm);
  # * The airports do not have routes between them: returns infinity;
  #
  # @param [String] first_port The first airport code.
  # @param [String] second_port The second airport code.
  #
  # @return [Integer] The distance between the two airports.
  #
  def get_connection(first_port, second_port)
    case
      when one_does_not_exist(first_port, second_port) then
        -1
      when first_port == second_port then
        0
      else
        @node_hash[first_port][second_port]
    end
  end

  # Adds a note to the graph without connection. The distance to any other node is infinite.
  #
  # @param [String] port_code the airport code.
  #
  # @return [void]
  #
  def add_node(port_code)
    @node_hash[port_code] = Hash.new(INFTY)
  end

  # Gets the URL addition for the JSON graph. The resulting string has every airport connection separated by
  # commas and using plus signs (+) for spaces. Examples: 'SCL-MEX', 'SCL-LIM,+LIM-BOG'
  #
  # @return [String] a string containing each airport connection.
  #
  def get_url_addition
    @connectors.get_connection_url
  end

  # @param [String] city_code
  #
  # @return [Hash]
  #
  def get_closest_cities(city_code)
    @node_hash[city_code]
  end

  # Creates the graph using the provided JSON file.
  #
  # @return [void]
  #
  def create_graph_from_json(json_file_name)
    read_me = Reader.new(json_file_name)
    graph_hash = read_me.get_graph_hash
    graph_hash.each do |route|
      add_connection(route['ports'][0], route['ports'][1], route['distance'])
    end
  end

  # Allows the removal of a city inside the graph.
  #
  # @param [String] city_node
  #
  # @return [void]
  #
  def remove_city(city_node)
    if @node_hash.include? (city_node)
      @node_hash.delete(city_node)
      @node_hash.each_value do |node_hash|
        if node_hash.include? (city_node)
          node_hash.delete(city_node)
        end
      end
    end
  end

  # Allows the removal of a connection inside the graph, but in only one direction.
  #
  # @param [String] first_node
  # @param [String] second_node
  #
  # @return [void]
  #
  def delete_direction(first_node, second_node)
    unless one_does_not_exist(first_node, second_node)
      @node_hash[first_node][second_node] = INFTY
      if @node_hash[second_node][first_node] == INFTY
        @connectors.delete_connection(first_node, second_node)
      end
    end
  end

  # Allows the removal of a connection inside the graph, in both directions.
  #
  # @param [String] first_node
  # @param [String] second_node
  #
  # @return [void]
  #
  def delete_connection(first_node, second_node)
    delete_direction(first_node, second_node)
    delete_direction(second_node, first_node)
    @connectors.delete_connection(first_node, second_node)
  end

  # Applies Dijkstra's algorithm in a node (the source).
  #
  # @param [String] source the source node taken as reference.
  #
  # @return [Array<Hash>] two hashes: one for the distance between two nodes (via Dijkstra), and one for the previous
  # node to any given node (in order to rescue the entire path from the source recursively).
  #
  def dijkstra(source)

    dist = Hash.new(INFTY)
    prev = Hash.new

    dist[source] = 0
    queue = Array.new

    @node_hash.each_key{|node| queue.push(node)}

    until queue.empty?
      u = min_dist(dist, queue)
      queue.delete(u)

      @node_hash[u].each do |v, length_u_v|
        if queue.include?(v)
          alt = dist[u] + length_u_v
          if alt < dist[v]
            dist[v] = alt
            prev[v] = u
          end
        end
      end

    end

    [dist, prev]
  end

  private

  # Finds the node inside a queue with the minimum distance to a source node (omitted).
  #
  # @param [Hash] dist a Hash containing the evaluated distance from the source (via Dijkstra).
  # @param [Array] queue an array containing non-evaluated nodes (via Dijkstra).
  #
  # @return [String]
  #
  def min_dist(dist, queue)
    reference_dist = INFTY
    reference_node = String.new
    queue.each do |node|
      if dist[node] < reference_dist
        reference_dist = dist[node]
        reference_node = node
      end
    end
    reference_node
  end

  #
  # @param [String] node
  #
  # @param [Hash] node_hash
  #
  # @return [String]
  #
  def get_node_connections(node, node_hash)
    node_string = "\n{#{node}"
    unless node_hash.empty?
      node_string << add_to_string(node_hash)
    end
    node_string << '}'
  end

  # @param [Hash] node_hash
  #
  # @return [String]
  #
  def add_to_string(node_hash)
    nodes_and_dist = ' => '
    node_hash.each do |port, dist|
      nodes_and_dist << "{#{port}: #{dist}}, "
    end
    nodes_and_dist[0..-3]
  end

  # Checks if at least one of the nodes does not exist in the graph.
  #
  # @param [String] first_port
  # @param [String] second_port
  #
  # @return [Boolean]
  #
  def one_does_not_exist(first_port, second_port)
    !@node_hash.include? first_port or !@node_hash.include? second_port
  end

  # Adds a node to the graph if it does not exist yet.
  #
  # @param [String] port
  #
  # @return [void]
  #
  def add_if_non_existing(port)
    unless @node_hash.include? port
      add_node(port)
    end
  end

  # @param [String] first_port
  # @param [String] second_port
  # @param [Integer] distance
  #
  # @return [void]
  #
  def account_for_shortest_flight(first_port, second_port, distance)
    if @shortest_flight.empty?
      @shortest_flight[:distance] = distance
      @shortest_flight[:ports] = [first_port, second_port]
    elsif @shortest_flight[:distance] > distance
      @shortest_flight[:distance] = distance
      @shortest_flight[:ports] = [first_port, second_port]
    end
  end

  # @param [String] first_port
  # @param [String] second_port
  # @param [Integer] distance
  #
  # @return [void]
  #
  def account_for_longest_flight(first_port, second_port, distance)
    if @longest_flight.empty?
      @longest_flight[:distance] = distance
      @longest_flight[:ports] = [first_port, second_port]
    elsif @longest_flight[:distance] < distance
      @longest_flight[:distance] = distance
      @longest_flight[:ports] = [first_port, second_port]
    end
  end

end