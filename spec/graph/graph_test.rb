require_relative '../../lib/graph/graph'
require 'test/unit'

class GraphTest < Test::Unit::TestCase

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
  # a method that receives airport names in no specific order.
  #
  # First case: the airports are connected.
  def test_read_valid_airport_distance
    assert_equal(Graph.distance_between('LIM','SCL'), 2453)
  end


end