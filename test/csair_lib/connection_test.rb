require 'test/unit'
require_relative '../../lib/csair_lib/graph'
require_relative '../../lib/csair_lib/connection'

# Test unit created to test changes in connections.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class ConnectionTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @simple_graph = Graph.new
    @simple_connectors = Connection.new
  end

  # Confirms that a newly-created Connection object has an empty URL addition.
  #
  # @return [void]
  #
  def test_initialization
    assert_equal(@simple_connectors.get_connection_url, '')
  end

  # Tests the simple addition of two connected nodes to a Connection object. The nodes must be upcase in the URL
  # addition.
  #
  # @return [void]
  #
  def test_simple_addition
    @simple_connectors.add_connection('def', 'abc')
    assert_equal(@simple_connectors.get_connection_url, 'ABC-DEF')
  end

  # Tests the alphabetical order of the whole URL addition, both inside each connection and between them. Not only
  # that, tests the addition of plus signs (+) in the place of blank spaces as well.
  #
  # @return [void]
  #
  def test_url_alphabetical_order
    @simple_connectors.add_connection('def', 'abc')
    @simple_connectors.add_connection('geg', 'abd')
    @simple_connectors.add_connection('gef', 'abd')
    assert_equal(@simple_connectors.get_connection_url, 'ABC-DEF,+ABD-GEF,+ABD-GEG')
  end

  # Tests the removal of one connection between nodes, in terms of its URL addition.
  #
  # @return [void]
  #
  def test_connection_removal
    @simple_connectors.add_connection('def', 'abc')
    @simple_connectors.add_connection('geg', 'abd')
    @simple_connectors.add_connection('gef', 'abd')
    assert_equal(@simple_connectors.get_connection_url, 'ABC-DEF,+ABD-GEF,+ABD-GEG')
    @simple_connectors.delete_connection('ABC', 'DEF')
    assert_equal(@simple_connectors.get_connection_url, 'ABD-GEF,+ABD-GEG')
  end

end