# Module that uses the Dijkstra's algorithm to find the shortest path between nodes.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
module Dijkstra

  # Reference value for infinity.
  INFTY = 1.0/0.0


  # Applies Dijkstra's algorithm in a node (the source).
  #
  # @param [String] source the source node taken as reference.
  # @param [Hash] node_hash the graph hash from a Graph object.
  #
  # @return [Array<Hash>] two hashes: one for the distance between two nodes (via Dijkstra),
  # and one for the previous node to any given node (in order to rescue the entire path
  # from the source recursively).
  #
  def dijkstra(source, node_hash)

    dist = Hash.new(INFTY)
    prev = Hash.new

    dist[source] = 0
    remaining_nodes = Array.new

    node_hash.each_key { |node| remaining_nodes.push(node) }

    until remaining_nodes.empty?
      u = min_dist(dist, remaining_nodes)
      remaining_nodes.delete(u)

      node_hash[u].each do |v, length_u_v|
        if remaining_nodes.include?(v)
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

  # Finds the shortest path between two nodes using Dijkstra's algorithm to iterate over
  # previous nodes.
  #
  # @param [String] source
  # @param [String] destination
  # @param [Hash] prev
  #
  # @return [Array<String>]
  #
  def create_shortest_path(source, destination, prev)
    path_array = []
    unless source == destination
      previous_node = destination
      until previous_node == source
        path_array << previous_node
        previous_node = prev[previous_node]
      end
    end
    path_array << source
    path_array.reverse
  end

  # Gets the string corresponding to a path array between two nodes.
  #
  # @param [Array] path_array
  #
  # @return [String]
  #
  def create_url_from_path(path_array)
    final_url = ''
    unless path_array.size == (1 or 0)
      path_array.each_index do |index|
        final_url << "#{path_array[index]}-#{path_array[index+1]},+"
      end
      final_url = final_url[0..-9]
    end
    final_url
  end

end