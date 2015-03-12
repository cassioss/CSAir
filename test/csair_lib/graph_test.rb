require 'test/unit'
require_relative '../../lib/csair_lib/graph'

# Class created to test graph features, like adding nodes, removing connections, calculating the shortest
# distance between two airports, and so on.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class GraphTest < Test::Unit::TestCase

  INFTY = 1.0/0.0

  def setup
    @simple_graph = Graph.new
  end

  # Tests if the insertion of connection between ports is bilateral.
  #
  # @return [void]
  #
  def test_add_connection
    @simple_graph.add_connection('MEX', 'CHI', 2131)
    @simple_graph.add_connection('MEX', 'SCL', 2123)
    assert_equal(@simple_graph.get_connection('MEX', 'CHI'), 2131)
    assert_equal(@simple_graph.get_connection('CHI', 'MEX'), 2131)
  end

  # Tests getting the connection of an airport that does not exist.
  #
  # @return [void]
  #
  def test_get_non_existing_airport
    @simple_graph.add_connection('MEX', 'CHI', 3141)
    assert_equal(@simple_graph.get_connection('MEX', 'ABC'), -1)
    assert_equal(@simple_graph.get_connection('ABC', 'MEX'), -1)
  end

  # Tests getting the connection of two existing but disconnected airports.
  #
  # @return [void]
  #
  def test_get_disconnected_airports
    @simple_graph.add_node('MEX')
    @simple_graph.add_node('CHI')
    assert_equal(@simple_graph.get_connection('MEX', 'CHI'), INFTY)
    assert_equal(@simple_graph.get_connection('CHI', 'MEX'), INFTY)
  end

  # Tests getting the connection between an airport and itself.
  #
  # @return [void]
  #
  def test_get_same_airport
    @simple_graph.add_node('MEX')
    assert_equal(@simple_graph.get_connection('MEX', 'MEX'), 0)
  end

  # Tests the deletion of a graph node.
  #
  # @return [void]
  #
  def test_delete_node
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.remove_city('ABC')
    assert_equal(@simple_graph.get_connection('ABC', 'DEF'), -1)
  end

  # Tests the deletion of a connection between nodes.
  #
  # @return [void]
  #
  def test_delete_connection
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.remove_connection('ABC', 'DEF')
    assert_equal(@simple_graph.get_connection('ABC', 'DEF'), INFTY)
  end

end