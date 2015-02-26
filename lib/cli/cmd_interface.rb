require_relative '../../lib/graph/reader'

class CmdInterface

  def initialize
    @read_me = Reader.new
  end

  def basic_for_loop
    loop do
      main_menu
      $stdout.flush
      character = gets.chomp
      case character
        when '1' then list_all_cities
        when '2' then
          give_space
          get_city
          $stdout.flush
          city_name = gets.chomp
          get_info_if_exists(city_name)
        when '3' then show_statistics
        else break
      end
      $stdout.flush
      gets.chomp
      give_space
    end
  end

  private
  def give_space
    print "\n\n\n\n\n\n"
  end

  def list_all_cities
    puts 'ANYTHING'
  end

  def main_menu
    puts 'Welcome to CSAir!'
    puts 'Choose an option:'
    puts '(Press 1) List all the cities that CSAir flies to'
    puts '(Press 2) See an specific information about a specific city in CSAir network'
    puts '(Press 3) List CSAir statistics'
    puts '(Press any other key) Exit menu'
    print 'Your option: '
  end

  def get_city
    print 'Write the name of the city and press enter:'
  end

  def get_info_if_exists(city)
    if @read_me.city_exists?(city)
      specific_info(city)
    else
      puts "The city you typed does not exist in our database.\nPress N to exit. "
    end
  end

  def specific_info(city)
    puts "Learn more about #{city}"
    puts 'Choose an option:'
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
  end

  def show_statistics
    give_space
    puts 'ANYTHING'
  end

end