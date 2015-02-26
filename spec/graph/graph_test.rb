require_relative '../../lib/graph/graph'
require 'test/unit'

class GraphTest < Test::Unit::TestCase

  INFTY = 1.0/0.0

  # Tests if the insertion of connection between ports is bilateral.
  def test_add_connection
    simple_graph = Graph.new
    simple_graph.add_connection('MEX', 'CHI', 2131)
    assert_equal(simple_graph.get_connection('MEX', 'CHI'), 2131)
    assert_equal(simple_graph.get_connection('CHI', 'MEX'), 2131)
  end

  # Tests getting the connection of an airport that does not exist.
  def test_get_non_existing_port
    simple_graph = Graph.new
    simple_graph.add_connection('MEX', 'CHI', 3141)
    assert_equal(simple_graph.get_connection('MEX', 'ABC'), -1)
    assert_equal(simple_graph.get_connection('ABC', 'MEX'), -1)
  end

  # Tests getting the connection of two existing but disconnected airports.
  def test_get_non_existing_port
    simple_graph = Graph.new
    simple_graph.add_connection('MEX', 'CHI', 3141)
    assert_equal(simple_graph.get_connection('MEX', 'ABC'), -1)
    assert_equal(simple_graph.get_connection('ABC', 'MEX'), -1)
  end


end