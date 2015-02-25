require_relative '../../lib/graph/node'
require 'test/unit'

class NodeTest < Test::Unit::TestCase

  INFTY = 1.0/0.0

  def test_distance_to_node
    mexico = Node.new('MEX')
    mexico.add_connection('SCL', 2453)
    assert_equal(mexico.distance_to('SCL'), 2453)
  end

  def test_distance_to_itself
    mexico = Node.new('MEX')
    assert_equal(mexico.distance_to('MEX'), 0)
  end

  def test_dist_to_disconnected_node
    mexico = Node.new('MEX')
    assert_equal(mexico.distance_to('SCL'), INFTY)
  end

end