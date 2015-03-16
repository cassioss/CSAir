# Class that keeps track of each connection called by a graph.
#
# @author Cassio dos Santos Sousa
# @version 1.0
# @see Graph
#
class Connection

  # Initializes a sorted set that keeps track of each connection.
  #
  # @return [void]
  #
  def initialize
    @connection_set = SortedSet.new
  end

  # @param [String] first
  # @param [String] second
  #
  # @return [void]
  #
  def add_connection(first, second)
    unless first == second
      @connection_set.add(alphabetical_order(first, second))
    end
  end

  # Gets the URL required to connect to the CSAir map.
  #
  # @return [String]
  #
  def get_connection_url
    url_string = String.new
    @connection_set.each do |connection|
      url_string << connection + ',+'
    end
    url_string[0..-3]
  end

  # Deletes an existing connection between two nodes. This is required when both ways of
  # a connection are deleted.
  #
  # @return [void]
  #
  def delete_connection(first, second)
    @connection_set.delete(alphabetical_order(first, second))
  end

  private

  # Adds a dash between two uppercase words.
  #
  # @param [String] two
  # @param [String] words
  #
  # @return [String]
  #
  def dash_between_uppercase(two, words)
    two.upcase + '-' + words.upcase
  end

  # Evaluates two words in terms of alphabetical order, having lowercase as reference.
  #
  # @param [String] first
  # @param [String] second
  #
  # @return [String]
  #
  def alphabetical_order(first, second)
    first.downcase < second.downcase ? dash_between_uppercase(first, second) : dash_between_uppercase(second, first)
  end

end