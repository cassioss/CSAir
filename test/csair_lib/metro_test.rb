require 'test/unit'
require_relative '../../lib/csair_lib/metro'

class MetroTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    simple_metro = Metro.new('Test City', 'United States', 'America', -6, 100000, {"N" => 44, "W" => 80}, 1)
  end

  # Tests changing the timezone
  #
  # @return [void]
  #
  def test_change_timezone
    simple_metro.edit_information_about_city()
  end
end