class AllMetros

  # Creates a new hash that keeps track of every metro in a network.
  #
  # @return [void]
  #
  def initialize
    @all_metros = Hash.new
  end

  # Adds a new metro to the hash.
  #
  # @param [Hash] airport
  #
  # @return [void]
  #
  def add_metro(airport)
    @all_metros[airport['code']] = Metro.new(airport['name'], airport['country'], airport['continent'],
                                         airport['timezone'], airport['population'],
                                         airport['coordinates'], airport['region'])
  end

end