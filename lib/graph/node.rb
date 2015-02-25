class Node

  INFTY = 1.0/0.0

  # @param [String] airport_name
  def initialize(airport_name)
    @airport = airport_name
    @connections = Hash.new
  end

  def add_comma_to(my_string)
    my_string << ','
  end

  def add_connections_to_string
    all_connections = String.new
    add_comma = false
    @connections.each do |port, dist|
      if add_comma
        add_comma_to(all_connections)
      else
        add_comma = true
      end
      all_connections << " {'#{port}' => #{dist}}"
    end
    all_connections
  end

  # Returns a string containing the airpot name and all its
  # connections, if any.
  def to_s
    airport_string = "Node{'#{@airport}'}"
    unless @connections.empty?
      airport_string << ':' << add_connections_to_string
    end
    airport_string
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
      0
    elsif !@connections.include?(airport)
      1.0/0.0
    else
      @connections[airport]
    end
  end

end