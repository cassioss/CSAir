# encoding: utf-8

require 'test/unit'
require_relative '../../lib/csair_lib/metro'

# Test unit created to test changes in Metro attributes accordingly.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class MetroTest < Test::Unit::TestCase

  # Sets two metros, one with positive timezone, and one with negative timezone.
  #
  # @return [void]
  #
  def setup
    @positive_metro = Metro.new('Test City', 'United States', 'America', 5, 100000, {'N' => 44, 'W' => 80}, 1)
    @negative_metro = Metro.new('Test City', 'United States', 'America', -5, 100000, {'N' => 44, 'W' => 80}, 1)
  end


  # Tests whether a positive timezone prints the plus sign (+) when read.
  #
  # @return [void]
  #
  def test_plus_sign_timezone
    assert_equal(@positive_metro.timezone, 'GMT +5')
  end

  # Tests whether a negative timezone prints the minus sign (-) when read.
  #
  # @return [void]
  #
  def test_minus_sign_timezone
    assert_equal(@negative_metro.timezone, 'GMT -5')
  end

  # Tests changing the timezone correctly.
  #
  # @return [void]
  #
  def test_change_valid_timezone
    @positive_metro.edit_information_about_city('4', -5)
    assert_equal(@positive_metro.timezone, 'GMT -5')
  end

  # Tests changing to a timezone with the wrong type. First case: String.
  #
  # @return [void]
  #
  def test_timezone_type_error_1
    exception = assert_raise(TypeError) {
      @positive_metro.edit_information_about_city('4', '-5')
    }
    assert_equal(exception.message, 'The new timezone is not an Integer value')
  end

  # Tests changing to a timezone with the wrong type. Second case: Float.
  #
  # @return [void]
  #
  def test_timezone_type_error_2
    exception = assert_raise(TypeError) {
      @positive_metro.edit_information_about_city('4', -4.1)
    }
    assert_equal(exception.message, 'The new timezone is not an Integer value')
  end

  # Tests changing to a timezone out of bounds (over 12 hours of difference).
  #
  # @return [void]
  #
  def test_timezone_range_error
    exception = assert_raise(RangeError) {
      @positive_metro.edit_information_about_city('4', -13)
    }
    assert_equal(exception.message, 'New timezone over 12 hours of difference')
  end



  # Tests changing to valid coordinates.
  #
  # @return [void]
  #
  def test_change_valid_coordinates
    @positive_metro.edit_information_about_city('5', {'S' => 10, 'E' => 20})
    assert_equal(@positive_metro.coordinates, '10°S, 20°E')
  end

  # Tests changing coordinates without a hash.
  #
  # @return [void]
  #
  def test_change_coords_to_not_hash
    exception = assert_raise(TypeError) {
      @positive_metro.edit_information_about_city('5', '10°S, 20°E')
    }
    assert_equal(exception.message, 'The new coordinates do not make a Hash')
  end

  # Tests changing to over two coordinates.
  #
  # @return [void]
  #
  def test_change_over_two_coords
    exception = assert_raise(ArgumentError) {
      @positive_metro.edit_information_about_city('5', {'S' => 10, 'E' => 20, 'SE' => 30})
    }
    assert_equal(exception.message, 'There are not exactly two coordinates in the Hash')
  end

  # Tests changing to only one coordinate.
  #
  # @return [void]
  #
  def test_change_to_one_coordinate
    exception = assert_raise(ArgumentError) {
      @positive_metro.edit_information_about_city('5', {'S' => 10})
    }
    assert_equal(exception.message, 'There are not exactly two coordinates in the Hash')
  end

  # Tests changing to a latitude different from North ('N') or South ('S').
  #
  # @return [void]
  #
  def test_latitude_not_n_or_s
    exception = assert_raise(ArgumentError) {
      @positive_metro.edit_information_about_city('5', {'O' => 10, 'E' => 20})
    }
    assert_equal(exception.message, 'First coordinate is not N or S')
  end

  # Tests changing to a longitude different from East ('E') or West ('W').
  #
  # @return [void]
  #
  def test_longitude_not_e_or_w
    exception = assert_raise(ArgumentError) {
      @positive_metro.edit_information_about_city('5', {'N' => 10, 'O' => 20})
    }
    assert_equal(exception.message, 'Second coordinate is not E or W')
  end

  # Tests changing to a negative latitude.
  #
  # @return [void]
  #
  def test_latitude_lower_than_0
    exception = assert_raise(RangeError) {
      @positive_metro.edit_information_about_city('5', {'S' => -10, 'E' => 20})
    }
    assert_equal(exception.message, 'Latitude out of bounds (must be between 0 and 90 degrees)')
  end

  # Tests changing to a latitude over 90 degrees.
  #
  # @return [void]
  #
  def test_latitude_over_90
    exception = assert_raise(RangeError) {
      @positive_metro.edit_information_about_city('5', {'S' => 100, 'E' => 20})
    }
    assert_equal(exception.message, 'Latitude out of bounds (must be between 0 and 90 degrees)')
  end

  # Tests changing to a negative longitude.
  #
  # @return [void]
  #
  def test_longitude_lower_than_0
    exception = assert_raise(RangeError) {
      @positive_metro.edit_information_about_city('5', {'S' => 10, 'E' => -20})
    }
    assert_equal(exception.message, 'Longitude out of bounds (must be between 0 and 180 degrees)')
  end

  # Tests changing to a negative latitude.
  #
  # @return [void]
  #
  def test_longitude_over_180
    exception = assert_raise(RangeError) {
      @positive_metro.edit_information_about_city('5', {'S' => 10, 'E' => 181})
    }
    assert_equal(exception.message, 'Longitude out of bounds (must be between 0 and 180 degrees)')
  end



  # Tests changing the population correctly.
  #
  # @return [void]
  #
  def test_change_valid_population
    @positive_metro.edit_information_about_city('6', 1234567)
    assert_equal(@positive_metro.population, '1234567')
  end

  # Tests changing to no population
  #
  # @return [void]
  #
  def test_change_to_zero_population
    @positive_metro.edit_information_about_city('6', 0)
    assert_equal(@positive_metro.population, '0')
  end

  # Tests changing to a population with the wrong type. First case: String.
  #
  # @return [void]
  #
  def test_population_type_error_1
    exception = assert_raise(TypeError) {
      @positive_metro.edit_information_about_city('6', '1000')
    }
    assert_equal(exception.message, 'The new population is not an Integer value')
  end

  # Tests changing to a population with the wrong type. Second case: Float.
  #
  # @return [void]
  #
  def test_population_type_error_2
    exception = assert_raise(TypeError) {
      @positive_metro.edit_information_about_city('6', 123.4)
    }
    assert_equal(exception.message, 'The new population is not an Integer value')
  end

  # Tests changing to a negative population.
  #
  # @return [void]
  #
  def test_negative_population_error
    exception = assert_raise(RangeError) {
      @positive_metro.edit_information_about_city('6', -130000)
    }
    assert_equal(exception.message, 'Negative value for population')
  end

end