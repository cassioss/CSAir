class Graph
  INFTY = 1.0/0.0

  def initialize
    @node_hash = Hash.new
  end

  # @param [String] first_port
  # @param [String] second_port
  # @param [Integer] distance
  def add_connection(first_port, second_port, distance)
    check_existence_of(first_port)
    check_existence_of(second_port)
    @node_hash[first_port][second_port] = distance
    @node_hash[second_port][first_port] = distance
  end

  # @param [String] first_port
  # @param [String] second_port
  # @return [Integer]
  def get_connection(first_port, second_port)
    if one_does_not_exist(first_port, second_port)
      -1
    else
      @node_hash[first_port][second_port]
    end
  end

  private
  # @param [String] first_port
  # @param [String] second_port
  def one_does_not_exist(first_port, second_port)
    !@node_hash.include? first_port or !@node_hash.include? second_port
  end

  # @param [String] port_name
  def add_node(port_name)
    @node_hash[port_name] = Hash.new(INFTY)
  end

  # @param [String] port
  def check_existence_of(port)
    unless @node_hash.include? port
      add_node(port)
    end
  end


end