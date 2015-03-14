require 'test/unit'
require_relative '../../../lib/csair_lib/graph'

class DijkstraTest < Test::Unit::TestCase

  # Calls a Graph object specifically prepared for most of Dijkstra's evaluations.
  #
  # @return [void]
  #
  def setup
    @dijkstra_graph = Graph.new
    @dijkstra_graph.add_connection('ABC', 'DEF', 20)
    @dijkstra_graph.add_connection('DEF', 'GHI', 20)
    @dijkstra_graph.add_connection('GHI', 'JKL', 20)
    @dijkstra_graph.add_connection('ABC', 'GHI', 50)  # Not the shortest path from 'ABC' to 'GHI'
    @dijkstra_graph.add_connection('ABC', 'JKL', 50)  # Shortest path from 'ABC' to 'JKL'
  end

  # Tests the correct application of Dijkstra's algorithm in a graph.
  #
  # @return [void]
  #
  def test_correct_dijkstra
    dist, prev = @dijkstra_graph.dijkstra('ABC', @dijkstra_graph.node_hash)

    assert_equal(dist['ABC'], 0)
    assert_equal(dist['DEF'], 20)
    assert_equal(dist['GHI'], 40)

    assert_nil(prev['ABC'])
    assert_equal(prev['DEF'], 'ABC')
    assert_equal(prev['GHI'], 'DEF')
  end

  # Tests if the Dijkstra's algorithm was applied correctly for an edge case
  # (which fails for a purely greedy algorithm).
  #
  # @return [void]
  #
  def test_dijkstra_edge_case
    dist, prev = @dijkstra_graph.dijkstra('ABC', @dijkstra_graph.node_hash)
    assert_equal(dist['JKL'], 50)
    assert_equal(prev['JKL'], 'ABC')
  end

end