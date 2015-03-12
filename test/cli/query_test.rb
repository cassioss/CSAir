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

end