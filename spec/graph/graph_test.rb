require_relative '../../lib/graph/graph'
require 'test/unit'

class GraphTest < Test::Unit::TestCase

  INFTY = 1.0/0.0

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Tests the correct creation of a hash from the JSON
  # source file.
  def test_hash_from_json
    intended_json_hash = Graph.json_file_hash
    assert_equal(intended_json_hash['routes'][0]['distance'], 2453)
  end

  # Tests the correct reading of the JSON hash using
  # a method that receives two airport names in no specific order.
  #
  # First case: the airports are connected.
  def test_read_valid_port_distance
    assert_equal(Graph.distance_between('LIM','SCL'), 2453)
  end

  # Tests the correct reading of the JSON hash using
  # a method that receives two airport names in no specific order.
  #
  # Second case: the airports are the same.
  def test_read_same_port_distance
    assert_equal(Graph.distance_between('LIM','LIM'), 0)
  end

  # Tests the correct reading of the JSON hash using
  # a method that receives two airport names in no specific order.
  #
  # Third case: the airports exist but are not connected.
  def test_read_disconnected_ports
    assert_equal(Graph.distance_between('LIM','LAX'), INFTY)
  end

  # Tests the correct reading of the JSON hash using
  # a method that receives two airport names in no specific order.
  #
  # Fourth case: one of the airports does not exist in the JSON file.
  def test_read_unexistent_port
    assert_equal(Graph.distance_between('LIM','ABC'), -1)
  end

end