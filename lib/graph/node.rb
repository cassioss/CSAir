class Node

  INFTY = 1.0/0.0

  # @param [String] airport_name
  def initialize(airport_name)
    @airport = airport_name
    @connections = Hash.new
  end

  def to_s
    puts "Node{'#{@airport}'}"
  end
  # @param [String] port
  # @param [Integer] distance
  def add_connection(port, distance)
    @connections[port] = distance
  end

  # @param [String] airport
  # @return [Integer]
  def distance_to(airport)
    if airport == @airport
      return 0
    elsif !@connections.include?(airport)
      return 1.0/0.0
    else
      return @connections[airport]
    end
  end

  a = Node.new('MEX')
  p a

end