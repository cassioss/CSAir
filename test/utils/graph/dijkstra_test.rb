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

    @dijkstra_graph.evaluate_dijkstra

    @path_to_abc = @dijkstra_graph.shortest_path_between('ABC', 'ABC')
    @path_to_def = @dijkstra_graph.shortest_path_between('ABC', 'DEF')
    @path_to_ghi = @dijkstra_graph.shortest_path_between('ABC', 'GHI')
    @path_to_jkl = @dijkstra_graph.shortest_path_between('ABC', 'JKL')
  end

  # Tests the correct application of Dijkstra's algorithm in a graph.
  #
  # @return [void]
  #
  def test_correct_dijkstra
    abc_dist = @dijkstra_graph.short_paths['ABC']['dist']
    abc_prev = @dijkstra_graph.short_paths['ABC']['prev']
    p @dijkstra_graph.short_paths['ABC'].nil?
    assert_equal(abc_dist['ABC'], 0)
    assert_equal(abc_dist['DEF'], 20)
    assert_equal(abc_dist['GHI'], 40)

    assert_nil(abc_prev['ABC'])
    assert_equal(abc_prev['DEF'], 'ABC')
    assert_equal(abc_prev['GHI'], 'DEF')
  end

  # Tests if the Dijkstra's algorithm was applied correctly for an edge case
  # (which fails for a purely greedy algorithm).
  #
  # @return [void]
  #
  def test_dijkstra_edge_case
    assert_equal(@dijkstra_graph.short_paths['ABC']['dist']['JKL'], 50)
    assert_equal(@dijkstra_graph.short_paths['ABC']['prev']['JKL'], 'ABC')
  end

  # Tests if the Dijkstra's path algorithm retrieves the correct nodes on the path.
  #
  # @return [void]
  #
  def test_dijkstra_path_nodes

    assert_equal(@path_to_abc, %w(ABC))
    assert_equal(@path_to_def, %w(ABC DEF))
    assert_equal(@path_to_ghi, %w(ABC DEF GHI))
    assert_equal(@path_to_jkl, %w(ABC JKL))
  end

  # Tests if the Dijkstra's path algorithm retrieves the correct URL for a path.
  #
  # @return [void]
  #
  def test_dijkstra_path_url
    url_to_abc = @dijkstra_graph.create_url_from_path(@path_to_abc)
    url_to_def = @dijkstra_graph.create_url_from_path(@path_to_def)
    url_to_ghi = @dijkstra_graph.create_url_from_path(@path_to_ghi)
    url_to_jkl = @dijkstra_graph.create_url_from_path(@path_to_jkl)

    assert_equal(url_to_abc, '')
    assert_equal(url_to_def, 'ABC-DEF')
    assert_equal(url_to_ghi, 'ABC-DEF,+DEF-GHI')
    assert_equal(url_to_jkl, 'ABC-JKL')
  end

end