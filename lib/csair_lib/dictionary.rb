require_relative 'metro'
require_relative 'reader'

class Dictionary

  attr_reader :metros

  def initialize
    @dict = Hash.new
    @metros = Hash.new
    get_metros_from_json
  end

# @param [String] name
  def encrypt(name)
    @dict[name.downcase]
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
    @dict.add_translation(airport[name], airport[code])
    @metros[airport[code]] = Metro.new(airport['name'], airport['country'], airport['continent'], airport['timezone'],
                                       airport['population'], airport['coordinates'], airport['region'])
  end

# @param [String] name
# @param [String] code
  def add_translation(name, code)
    @dict[name.downcase] = code
  end

end