require 'test/unit'
require_relative '../../../lib/model/graph/graph'

# Tests the statistics for the original (initial) JSON data for CSAir.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class MapDataGraphTest < Test::Unit::TestCase

  # Creates a new Graph object that already has read the original JSON file.
  #
  # @return [void]
  #
  def setup
    @simple_graph = Graph.new
    @simple_graph.create_graph_from_json('map_data.json')
  end

  # Tests if the shortest flight in the original CSAir network has 334 km and is from NYC to WAS.
  #
  # @return [void]
  #
  def test_original_shortest_flight
    assert_equal(@simple_graph.shortest_flight[:distance], 334)
    assert_equal(@simple_graph.shortest_flight[:ports].sort, %w(NYC WAS))
  end

  # Tests if the longest flight in the original CSAir network has 12051 km and is from LAX to SYD.
  #
  # @return [void]
  #
  def test_original_longest_flight
    assert_equal(@simple_graph.longest_flight[:distance], 12051)
    assert_equal(@simple_graph.longest_flight[:ports].sort, %w(LAX SYD))
  end

  # Tests if the average flight distance in the original (initial) CSAir network has 2300 km
  # (after turning it to an Integer).
  #
  # @return [void]
  #
  def test_original_average_flight
    assert_equal(@simple_graph.get_average_flight.to_i, 2300)
  end

end