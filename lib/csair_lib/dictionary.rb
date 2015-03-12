require_relative 'metro'
require_relative 'reader'

# Class that keeps track of every city name and airport code, in order to convert (encode/decode/translate) from
# one to the other whenever necessary.
#
# @author Cassio dos Santos Sousa
# @version 1.1
# @since 1.0
#
class Dictionary

  attr_reader :metros

  #
  # @return [void]
  #
  def initialize
    @dict_name_key = Hash.new
    @dict_key_name = Hash.new
    @metros = Hash.new
  end

  # @param [String] name
  # @param [String] code
  #
  # @return [void]
  #
  def add_translation(name, code)
    @dict_name_key[name.downcase] = code
    @dict_key_name[code] = name
  end

  # @param [String] name
  #
  # @return [String]
  #
  def encode(name)
    @dict_name_key[name.downcase]
  end

  # @param [String] key
  #
  # @return [String]
  #
  def unlock(key)
    @dict_key_name[key]
  end

  # @param [String] name
  #
  # @return [Boolean]
  #
  def city_exists?(name)
    @dict_name_key.include?(name)
  end


  # @param [String] city_name
  # @return [void]
  #
  def delete_translation(city_name)
    original_key = encode(city_name)
    @dict_key_name.delete(original_key)
    @dict_name_key.delete(city_name.downcase)
  end

  # Changes an airpot code for a given city.
  #
  # @return [void]
  #
  def change_airport_code(city_name, new_key)
    delete_translation(city_name)
    add_translation(city_name, new_key)
  end

  # Changes a city name without changing its code.
  #
  # @param [String] original_name
  # @param [String] new_name
  #
  # @return [void]
  #
  def change_city_name(original_name, new_name)
    code = encode(original_name)
    delete_translation(original_name)
    add_translation(new_name, code)
  end

  #
  # @return [void]
  #
  def get_metros_from_json
    read_me = Reader.new
    metro_hash = read_me.get_metro_hash
    metro_hash.each do |airport|
      add_metro(airport)
    end
  end

  private

  # @param [Hash] airport
  #
  # @return [void]
  #
  def add_metro(airport)
    add_translation(airport['name'], airport['code'])
    @metros[airport['code']] = Metro.new(airport['name'], airport['country'], airport['continent'],
                                         airport['timezone'], airport['population'],
                                         airport['coordinates'], airport['region'])
  end

end