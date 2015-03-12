require 'test/unit'
require_relative '../../lib/cli/query'

# Test unit created to test all queries that might be requested by a user.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class QueryTest < Test::Unit::TestCase

  # Initializes a new Query object for every test.
  #
  # @return [void]
  #
  def setup
    @queries = Query.new('map_data.json')
  end

  # Tests the time function (Float in hours) for any flight distance (Integer in km).
  #
  # @return [void]
  #
  def test_get_time
    assert_equal(@queries.get_time(400), 16.0/15.0)
    assert_equal(@queries.get_time(1100), 2.0)
  end

end