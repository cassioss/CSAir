require_relative 'metro'
require_relative 'reader'

class Dictionary

  attr_reader :metros

  def initialize
    @dict_name_key = Hash.new
    @dict_key_name = Hash.new
    @metros = Hash.new
    get_metros_from_json
  end

# @param [String] name
  def encode(name)
    @dict_name_key[name.downcase]
  end

# @param [String] key
  def unlock(key)
    @dict_key_name[key]
  end

# @param [String] name
  def city_exists?(name)
    @dict.include?(name)
  end

  private

  def get_metros_from_json
    read_me = Reader.new
    metro_hash = read_me.get_metro_hash
    metro_hash.each do |airport|
      add_metro(airport)
    end
  end

# @param [Hash] airport
  def add_metro(airport)
    add_translation(airport['name'], airport['code'])
    @metros[airport['code']] = Metro.new(airport['name'], airport['country'], airport['continent'], airport['timezone'],
                                       airport['population'], airport['coordinates'], airport['region'])
  end

# @param [String] name
# @param [String] code
  def add_translation(name, code)
    @dict_name_key[name.downcase] = code
    @dict_key_name[code] = name
  end

end