require_relative 'query'
require 'launchy'

# Class created for the command line User Interface (UI). The main module that runs it is in lib/csair.rb
#
# Author:: Cassio dos Santos Sousa
# Version:: 1.0
#
class CmdInterface

  def initialize
    @queries = Query.new
  end

  def basic_for_loop
    loop do
      main_menu
      $stdout.flush
      $stdin.flush
      character = gets.chomp
      case character
        when '1' then list_all_cities
        when '2' then get_city
        when '3' then show_statistics
        when '4' then show_url
        else
          break
      end
    end
  end

  private

  def list_all_cities
    puts "\nAll cities CSAir flies to:\n\n"
    @queries.list_all_cities
    print "\n"
  end

  def specific_information(city, number)
    @queries.get_information_from(city, number)
  end

  def show_statistics
    puts "\nCSAir statistics:\n\n"
    @queries.get_longest_flight
    @queries.get_shortest_flight
    @queries.get_average_distance
    @queries.get_biggest_city
    @queries.get_smallest_city
    @queries.get_average_city_size
    @queries.get_continents
    @queries.get_hub_cities
    print "\n"
  end

  def main_menu
    puts 'Welcome to CSAir!'
    puts 'Choose an option and press Enter:'
    puts '(Press 1) List all the cities that CSAir flies to'
    puts '(Press 2) See an specific information about a specific city in CSAir network'
    puts '(Press 3) List CSAir statistics'
    puts '(Press 4) Show all CSAir flights on a map'
    puts '(Press any other key) Exit menu'
    print 'Your option: '
  end

  def get_city
    print "\nWrite the name of the city and press Enter: "
    $stdin.flush
    $stdout.flush
    city = gets.chomp
    specific_info(city)
  end

  def specific_info(city)
    print "\nCity code: #{@queries.get_code(city)}\n\n"
    puts "Learn more about #{city}:"
    puts 'Choose an option and press Enter:'
    puts "(Press 1) See #{city}'s flight code"
    puts "(Press 2) See #{city}'s code"
    puts "(Press 3) See #{city}'s country"
    puts "(Press 4) See #{city}'s timezone"
    puts "(Press 5) See #{city}'s latitude and longitude"
    puts "(Press 6) See #{city}'s population"
    puts "(Press 7) See #{city}'s region"
    puts "(Press 8) See all cities accessible from #{city} via CSAir (and their distances)"
    puts '(Press any other key) Exit menu'
    print 'Your option: '
    $stdin.flush
    $stdout.flush
    option = gets.chomp
    puts "\n#{@queries.get_information_from(city, option)}\n\n"
  end

  def show_url
    Launchy.open(@queries.get_popup_url)
    print "\n"
  end
end