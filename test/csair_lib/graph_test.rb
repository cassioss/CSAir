require 'test/unit'
require_relative '../../lib/csair_lib/graph'

# Test unit created to test graph features, like adding nodes, removing connections, calculating the shortest
# distance between two airports, and so on.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class GraphTest < Test::Unit::TestCase

  INFTY = 1.0/0.0

  # Creates a new Graph object for every test.
  #
  # @return [void]
  #
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

  # Tests the deletion of one direction between two nodes (loses one way, but not both).
  #
  # @return [void]
  #
  def test_delete_direction
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.delete_direction('ABC', 'DEF')
    assert_equal(@simple_graph.get_connection('ABC', 'DEF'), INFTY)
    assert_equal(@simple_graph.get_connection('DEF', 'ABC'), 10)
  end

  # Tests the deletion of one connection between two nodes (loses both ways).
  #
  # @return [void]
  #
  def test_delete_connection
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.delete_connection('ABC', 'DEF')
    assert_equal(@simple_graph.get_connection('ABC', 'DEF'), INFTY)
    assert_equal(@simple_graph.get_connection('DEF', 'ABC'), INFTY)
  end

  # Tests the deletion of a connection between two nodes in the graph's URL addition.
  #
  # @return [void]
  #
  def test_delete_connection_url
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.add_connection('ABD', 'GEH', 10)
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')
    @simple_graph.delete_connection('DEF', 'ABC')
    assert_equal(@simple_graph.get_url_addition, 'ABD-GEH')
  end

  # Tests when to delete a connection between two nodes in the graph's URL addition, after only one of the directions has
  # been removed.
  #
  # @return [void]
  #
  def test_delete_direction_url
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.add_connection('ABD', 'GEH', 10)
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')
    @simple_graph.delete_direction('DEF', 'ABC')
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')
    @simple_graph.delete_direction('DEF', 'ABC')                      # Repeated again
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')  # for sanity check
    @simple_graph.delete_direction('ABC', 'DEF')
    assert_equal(@simple_graph.get_url_addition, 'ABD-GEH')
  end

  # Tests the lookup for shortest and longest flights on the network.
  #
  # @return [void]
  #
  def test_get_short_long_flights
    @simple_graph.add_connection('ABC', 'DEF', 1029)
    assert_equal(@simple_graph.shortest_flight['distance'], 1029)
    assert_equal(@simple_graph.longest_flight['distance'], 1029)
    @simple_graph.add_connection('BGH','ABC', 2030)
    assert_equal(@simple_graph.shortest_flight['distance'], 1029)
    assert_equal(@simple_graph.longest_flight['distance'], 2030)
    @simple_graph.add_connection('IBF','FBI', 1000)
    assert_equal(@simple_graph.shortest_flight['distance'], 1000)
    assert_equal(@simple_graph.longest_flight['distance'], 2030)
  end

end