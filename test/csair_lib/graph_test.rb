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
  def test_add_route
    @simple_graph.add_route('MEX', 'CHI', 2131)
    assert_equal(@simple_graph.get_route('MEX', 'CHI'), 2131)
    assert_equal(@simple_graph.get_route('CHI', 'MEX'), INFTY)
  end

  # Tests if the insertion of connection between ports is bilateral.
  #
  # @return [void]
  #
  def test_add_connection
    @simple_graph.add_connection('MEX', 'CHI', 2131)
    @simple_graph.add_connection('MEX', 'SCL', 2123)
    assert_equal(@simple_graph.get_route('MEX', 'CHI'), 2131)
    assert_equal(@simple_graph.get_route('CHI', 'MEX'), 2131)
  end

  # Tests getting the connection of an airport that does not exist.
  #
  # @return [void]
  #
  def test_get_non_existing_airport
    @simple_graph.add_connection('MEX', 'CHI', 3141)
    assert_equal(@simple_graph.get_route('MEX', 'ABC'), -1)
    assert_equal(@simple_graph.get_route('ABC', 'MEX'), -1)
  end

  # Tests getting the connection of two existing but disconnected airports.
  #
  # @return [void]
  #
  def test_get_disconnected_airports
    @simple_graph.add_node('MEX')
    @simple_graph.add_node('CHI')
    assert_equal(@simple_graph.get_route('MEX', 'CHI'), INFTY)
    assert_equal(@simple_graph.get_route('CHI', 'MEX'), INFTY)
  end

  # Tests getting the connection between an airport and itself.
  #
  # @return [void]
  #
  def test_get_same_airport
    @simple_graph.add_node('MEX')
    assert_equal(@simple_graph.get_route('MEX', 'MEX'), 0)
  end

  # Tests getting the correct average between the flights.
  #
  # @return [void]
  #
  def test_get_average_flight
    @simple_graph.add_connection('ABC', 'DEF', 20)  # 2 flights, total 40, average 20
    @simple_graph.add_connection('DEF', 'GHI', 20)  # 4 flights, total 80, average 20
    @simple_graph.add_route('ABC', 'GHI', 120)      # 5 flights, total 200, average 40
    assert_equal(@simple_graph.total_distance, 200)
    assert_equal(@simple_graph.num_of_flights, 5)
    assert_equal(@simple_graph.get_average_flight, 40.0)
  end

  # Tests getting the correct average between the flights.
  #
  # @return [void]
  #
  def test_average_removing_routes
    @simple_graph.add_connection('ABC', 'DEF', 20)
    assert_equal(@simple_graph.get_average_flight, 20.0)  # 2 flights, total 40, average 20
    @simple_graph.add_connection('DEF', 'GHI', 80)
    assert_equal(@simple_graph.get_average_flight, 50.0)  # 4 flights, total 200, average 50
    @simple_graph.delete_route('ABC', 'DEF')
    assert_equal(@simple_graph.get_average_flight, 60.0)  # 3 flights, total 180, average 60
  end

  # Tests the deletion of a graph node in terms of finding a route.
  #
  # @return [void]
  #
  def test_route_after_delete_node
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.delete_node('ABC')
    assert_equal(@simple_graph.get_route('ABC', 'DEF'), -1)
  end

  # Tests the deletion of one route between two nodes (loses one way, but not both).
  #
  # @return [void]
  #
  def test_delete_route
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.delete_route('ABC', 'DEF')
    assert_equal(@simple_graph.get_route('ABC', 'DEF'), INFTY)
    assert_equal(@simple_graph.get_route('DEF', 'ABC'), 10)
  end

  # Tests the deletion of one connection between two nodes (loses both ways).
  #
  # @return [void]
  #
  def test_delete_connection
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.delete_connection('ABC', 'DEF')
    assert_equal(@simple_graph.get_route('ABC', 'DEF'), INFTY)
    assert_equal(@simple_graph.get_route('DEF', 'ABC'), INFTY)
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

  # Tests when to delete a connection between two nodes in the graph's URL addition, after only one
  # of the directions has been removed.
  #
  # @return [void]
  #
  def test_delete_direction_url
    @simple_graph.add_connection('ABC', 'DEF', 10)
    @simple_graph.add_connection('ABD', 'GEH', 10)
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')
    @simple_graph.delete_route('DEF', 'ABC')
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')
    @simple_graph.delete_route('DEF', 'ABC')                          # Repeated again
    assert_equal(@simple_graph.get_url_addition, 'ABC-DEF,+ABD-GEH')  # for sanity check
    @simple_graph.delete_route('ABC', 'DEF')
    assert_equal(@simple_graph.get_url_addition, 'ABD-GEH')
  end


  # Tests the lookup for shortest and longest flights on the network.
  #
  # @return [void]
  #
  def test_get_short_long_flights
    # Adds the first connection - tests initial setting
    @simple_graph.add_connection('ABC', 'DEF', 1029)
    assert_equal(@simple_graph.shortest_flight[:distance], 1029)
    assert_equal(@simple_graph.longest_flight[:distance], 1029)

    # Adds a second, bigger connection - tests new longest flight
    @simple_graph.add_connection('BGH','ABC', 2030)
    assert_equal(@simple_graph.shortest_flight[:distance], 1029)
    assert_equal(@simple_graph.longest_flight[:distance], 2030)

    # Adds a third, smaller connection - tests new shortest flight
    @simple_graph.add_connection('IBF','FBI', 1000)
    assert_equal(@simple_graph.shortest_flight[:distance], 1000)
    assert_equal(@simple_graph.longest_flight[:distance], 2030)

    # Checks if the final ports in each extreme are correct
    assert_equal(@simple_graph.shortest_flight[:ports], %w(IBF FBI))
    assert_equal(@simple_graph.longest_flight[:ports], %w(BGH ABC))
  end

  # Tests the deletion of the shortest flight in the network.
  #
  # @return [void]
  #
  def test_delete_shortest_route
    @simple_graph.add_route('ABC', 'DEF', 100)
    @simple_graph.add_route('ABC', 'GHI', 20)
    assert_equal(@simple_graph.shortest_flight[:distance], 20)
    @simple_graph.delete_route('ABC', 'GHI')
    assert_equal(@simple_graph.shortest_flight[:distance], 100)
  end

  # Tests the deletion of the longest flight in the network.
  #
  # @return [void]
  #
  def test_delete_longest_route
    @simple_graph.add_route('ABC', 'DEF', 20)
    @simple_graph.add_route('ABC', 'GHI', 100)
    assert_equal(@simple_graph.longest_flight[:distance], 100)
    @simple_graph.delete_route('ABC', 'GHI')
    assert_equal(@simple_graph.longest_flight[:distance], 20)
  end

  # Tests the deletion of a graph node in terms of statistics (shortest/longest flight and
  # average flight distance).
  #
  # @return [void]
  #
  def test_stats_deleting_node
    @simple_graph.add_connection('ABC', 'DEF', 10)  # Shortest flight
    @simple_graph.add_connection('ABC', 'GHI', 20)  # Longest flights
    @simple_graph.add_connection('DEF', 'GHI', 18)  # 6 flights, total 96, average 16

    assert_equal(@simple_graph.shortest_flight[:distance], 10)
    assert_equal(@simple_graph.longest_flight[:distance], 20)
    assert_equal(@simple_graph.get_average_flight, 16)

    @simple_graph.delete_node('ABC')  # Loses reference for shortest/longest flight

    # There is only one reference for stats - 18 km
    assert_equal(@simple_graph.shortest_flight[:distance], 18)
    assert_equal(@simple_graph.longest_flight[:distance], 18)
    assert_equal(@simple_graph.get_average_flight, 18)
  end

  # Tests if the shortest flight in the original (initial) CSAir network has 334 km and is
  # from NYC to WAS.
  #
  # @return [void]
  #
  def test_original_shortest_flight
    @simple_graph.create_graph_from_json('map_data.json')
    assert_equal(@simple_graph.shortest_flight[:distance], 334)
    assert_equal(@simple_graph.shortest_flight[:ports].sort, %w(NYC WAS))
  end

  # Tests if the longest flight in the original (initial) CSAir network has 12051 km and is
  # from LAX to SYD.
  #
  # @return [void]
  #
  def test_original_longest_flight
    @simple_graph.create_graph_from_json('map_data.json')
    assert_equal(@simple_graph.longest_flight[:distance], 12051)
    assert_equal(@simple_graph.longest_flight[:ports].sort, %w(LAX SYD))
  end

  # Tests if the average flight distance in the original (initial) CSAir network
  # has 2300 km (after turning it to an Integer).
  #
  # @return [void]
  #
  def test_original_average_flight
    @simple_graph.create_graph_from_json('map_data.json')
    assert_equal(@simple_graph.get_average_flight.to_i, 2300)
  end



  # Tests if the Dijkstra's algorithm was applied correctly.
  #
  # @return [void]
  #
  def test_correct_dijkstra
    @simple_graph.add_connection('ABC', 'DEF', 20)
    @simple_graph.add_connection('DEF', 'GHI', 20)
    @simple_graph.add_connection('ABC', 'GHI', 50)

    dist, prev = @simple_graph.dijkstra('ABC')

    # Checks the shortest distance between 'ABC' and the other nodes
    assert_equal(dist['ABC'], 0)
    assert_equal(dist['DEF'], 20)
    assert_equal(dist['GHI'], 40)

    # Checks previous nodes following Dijkstra's algorithm
    assert_nil(prev['ABC'])
    assert_equal(prev['DEF'], 'ABC')
    assert_equal(prev['GHI'], 'DEF')
  end

  # Tests if the Dijkstra's algorithm was applied correctly for an edge case (which fails for a purely
  # greedy algorithm).
  #
  # @return [void]
  #
  def test_dijkstra_edge_case
    @simple_graph.add_connection('ABC', 'DEF', 20)
    @simple_graph.add_connection('DEF', 'GHI', 20)
    @simple_graph.add_connection('GHI', 'JKL', 20)
    @simple_graph.add_connection('ABC', 'JKL', 50)

    dist, prev = @simple_graph.dijkstra('ABC')

    # Checks the shortest distance between 'ABC' and the other nodes
    assert_equal(dist['ABC'], 0)
    assert_equal(dist['DEF'], 20)
    assert_equal(dist['GHI'], 40)
    assert_equal(dist['JKL'], 50)

    # Checks previous nodes following Dijkstra's algorithm
    assert_nil(prev['ABC'])
    assert_equal(prev['DEF'], 'ABC')
    assert_equal(prev['GHI'], 'DEF')
    assert_equal(prev['JKL'], 'ABC')
  end

end