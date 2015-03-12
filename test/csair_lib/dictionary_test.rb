require 'test/unit'
require_relative '../../lib/csair_lib/dictionary'

# Test unit created to test changes in Dictionary translations accordingly.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class DictionaryTest < Test::Unit::TestCase

  # Creates a new Dictionary object for every test, along with a simple translation.
  #
  # @return [void]
  #
  def setup
    @simple_dict = Dictionary.new
    @simple_dict.add_translation('Lima', 'LIM')
  end

  # Tests a correct addition of a translation.
  #
  # @return [void]
  #
  def test_correct_translation
    assert_equal(@simple_dict.encode('Lima'), 'LIM')
    assert_equal(@simple_dict.unlock('LIM'), 'Lima')
  end

  # Tests a correct deletion of a translation.
  #
  # @return [void]
  #
  def test_delete_translation
    @simple_dict.delete_translation('Lima')
    assert_nil(@simple_dict.encode('Lima'))
    assert_nil(@simple_dict.unlock('LIM'))
  end

  # Tests a correct change of an airport code in a given city.
  #
  # @return [void]
  #
  def test_change_airport_code
    @simple_dict.change_airport_code('Lima', 'LMA')
    assert_equal(@simple_dict.encode('Lima'), 'LMA')
    assert_equal(@simple_dict.unlock('LMA'), 'Lima')
    assert_nil(@simple_dict.unlock('LIM'))
  end

  # Tests a correct change of a city name, but not its airport code.
  #
  # @return [void]
  #
  def test_change_city_name
    @simple_dict.change_city_name('Lima', 'Limonada')
    assert_equal(@simple_dict.encode('Limonada'), 'LIM')
    assert_equal(@simple_dict.unlock('LIM'), 'Limonada')
    assert_nil(@simple_dict.encode('Lima'))
  end

end