class Connection

  attr_reader :connection_hash

  def initialize
    @connection_hash = SortedSet.new
  end

  # @param [String] first
  # @param [String] second
  def add_connection(first, second)
    unless first == second
      @connection_hash.add(alphabetical_order(first, second))
    end
  end

  private

  # @param [String] two
  # @param [String] words
  # @return [String]
  def dash_between(two, words)
    two + '-' + words
  end

  # @param [String] first
  # @param [String] second
  # @return [String]
  def alphabetical_order(first, second)
    first.downcase < second.downcase ? dash_between(first, second) : dash_between(second, first)
  end
end