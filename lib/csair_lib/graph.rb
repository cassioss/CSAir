require_relative 'reader'
require_relative 'connection'
require_relative '../utils/graph/dijkstra'

# Class created to handle graph creation and reading for the CSAir flight network.
#
# @author Cassio dos Santos Sousa
# @version 1.1
# @since 1.0
#
class Graph

  include Dijkstra
  attr_reader :node_hash, :total_distance, :num_of_flights, :shortest_flight, :longest_flight, :short_paths

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
    @short_paths = Hash.new
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

  # Gets the current average flight distance in the CSAir network, in kilometers.
  #
  # @return [Float]
  #
  def get_average_flight
    (1.0 * @total_distance) / (1.0 * @num_of_flights)
  end

  # Adds a route between two nodes in the graph, creating them if necessary. A route is unidirectional,
  # which means that the opposite direction might have either a different path, or no path at all.
  #
  # @param [String] first_port The first airport code
  # @param [String] second_port The second airport code
  # @param [Integer] distance The distance between the airports (by flight) in kilometers.
  #
  # @return [void]
  #
  def add_route(first_port, second_port, distance)
    add_if_non_existing(first_port)
    add_if_non_existing(second_port)
    @connectors.add_connection(first_port, second_port)
    @node_hash[first_port][second_port] = distance
    make_statistics(first_port, second_port, distance)
  end

  # Adds a connection between two nodes in the graph, creating them if necessary. A connection works
  # for both ways of a flight.
  #
  # @param [String] first_port The first airport code
  # @param [String] second_port The second airport code
  # @param [Integer] distance The distance between the airports (by flight) in kilometers.
  #
  # @return [void]
  #
  def add_connection(first_port, second_port, distance)
    add_route(first_port, second_port, distance)
    add_route(second_port, first_port, distance)
  end

  # Account every new route for statistics.
  #
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

  # Gets the value of a route (exclusively in one way) between two nodes (or airports).
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
  # @return [Integer] The distance between the two airports, in kilometers.
  #
  def get_route(first_port, second_port)
    if one_does_not_exist(first_port, second_port)
      -1
    elsif first_port == second_port
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
  def delete_node(city_node)
    if @node_hash.include? (city_node)
      delete_routes_from(city_node)
      @node_hash.each do |source_node, node_hash|
        if node_hash.include? (city_node)
          delete_route(source_node, city_node)
        end
      end
      @node_hash.delete(city_node)
      check_extreme_flights(city_node)
    end
  end


  # @param [String] source
  #
  # @return [void]
  #
  def delete_routes_from(source)
    @node_hash[source].each_key { |destination| delete_route(source, destination)}
  end

  # Check if the extreme flights (shortest and longest) contain a specific node (that's being
  # deleted), and if so, recalculate them.
  #
  # @param [String] node
  #
  # @return [void]
  #
  def check_extreme_flights(node)
    if @shortest_flight[:ports].include? node
      recalculate_shortest_flight
    end
    if @longest_flight[:ports].include? node
      recalculate_longest_flight
    end
  end

  # Allows the removal of a connection inside the graph, but in only one direction.
  #
  # @param [String] first_node
  # @param [String] second_node
  #
  # @return [void]
  #
  def delete_route(first_node, second_node)
    unless route_does_not_exist(first_node, second_node)
      @total_distance -= @node_hash[first_node][second_node]
      @num_of_flights -= 1
      @node_hash[first_node].delete(second_node)
      unless @node_hash[second_node].include? first_node
        @connectors.delete_connection(first_node, second_node)
      end
      check_extreme_flights(first_node) # Checking only one of the nodes is required
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
    delete_route(first_node, second_node)
    delete_route(second_node, first_node)
  end

  # Applies the Dijkstra's algorithm to every node in the graph.
  #
  # @return [void]
  #
  def evaluate_dijkstra
    @short_paths = Hash.new
    @node_hash.each_key do |node|
      dist, prev = dijkstra(node, @node_hash)
      @short_paths[node] = Hash.new
      @short_paths[node]['dist'] = dist
      @short_paths[node]['prev'] = prev
    end
  end

  # Finds a path array between two nodes after having applied Dijkstra's algorithm.
  #
  # @param [String] first_node
  # @param [String] second_node
  #
  # @return [Array<String>]
  #
  def shortest_path_as_array(first_node, second_node)
    create_shortest_path(first_node, second_node, @short_paths[first_node]['prev'])
  end

  # Finds a path string between two nodes after having applied Dijkstra's algorithm.
  #
  # @param [String] first_node
  # @param [String] second_node
  #
  # @return [String]
  #
  def shortest_path_as_string(first_node, second_node)
    create_url_from_path(shortest_path_as_array(first_node, second_node))
  end

  private

  # Recalculates the shortest flight on the network.
  #
  # @return [void]
  #
  def recalculate_shortest_flight
    short_flight_reference = INFTY
    first = String.new
    second = String.new
    @node_hash.each do |first_node, routes|
      routes.each do |second_node, distance|
        if distance < short_flight_reference
          short_flight_reference = distance
          first = first_node
          second = second_node
        end
      end
    end
    @shortest_flight[:distance] = short_flight_reference
    @shortest_flight[:ports] = [first, second]
  end

  # Recalculates the longest flight on the network.
  #
  # @return [void]
  #
  def recalculate_longest_flight
    long_flight_reference = 0
    first = String.new
    second = String.new
    @node_hash.each do |first_node, routes|
      routes.each do |second_node, distance|
        if distance > long_flight_reference
          long_flight_reference = distance
          first = first_node
          second = second_node
        end
      end
    end
    @longest_flight[:distance] = long_flight_reference
    @longest_flight[:ports] = [first, second]
  end

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

  # Checks if a certain route does not exist in the graph. Uses the previous method, but adds the
  # fact that a non-existing route between two existing nodes is infinite.
  #
  # @param [String] first_port
  # @param [String] second_port
  #
  # @return [Boolean]
  #
  def route_does_not_exist(first_port, second_port)
    one_does_not_exist(first_port, second_port) or @node_hash[first_port][second_port] == INFTY
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