require "pry"
class WhatsOnTap::CLI
  def call
    welcome
    get_locations
    list_locations
    get_beers
    list_beers
    get_a_beer_and_list_details
    restart_or_exit
    goodbye
  end

  def welcome
    puts ""
    puts "--------------------------------------------------------------------------------"
    puts "                            Welcome to What's On Tap!"
    puts "--------------------------------------------------------------------------------"
    puts ""
  end

  def get_locations
    puts "Please enter your city to find places offering craft beers on tap in your city."
    puts ""
    @city = gets.strip
    puts ""
    puts " #{@city.upcase}"
    puts "#{"-" * (@city.length + 2)}"
    WhatsOnTap::Scraper.make_locations(@city)
  end

  def list_locations
    WhatsOnTap::Location.select_by_city(@city).each.with_index(1) do |location_object, i|
      print " #{i}. #{location_object.name}"
      print " (#{location_object.type})" if location_object.type
      puts " ---> #{location_object.num_beers_on_tap}" if location_object.num_beers_on_tap
      puts ""
    end
  end

  def get_beers
    puts ""
    puts "Enter the number of the location for which you'd like to see the beer menu."
    puts "You can also type 'back' to try a new city, or type 'exit' to exit"
    puts ""

    input = gets.strip
    if input.to_i.between?(0,5)
      location_number = input.to_i - 1
      location = WhatsOnTap::Location.select_by_city(@city)[location_number]
      WhatsOnTap::Scraper.get_beer_list_page(location)
      WhatsOnTap::Scraper.make_beers

      name = WhatsOnTap::Location.all[location_number].name
      puts ""
      puts "Location: #{name}"
      puts "#{"-" * (name.length + 11)}"
      puts ""
    elsif input.downcase == "exit"
      exit
    elsif input.downcase == "back"
      puts ""
      get_locations
      list_locations
      get_beers
    else
      puts ""
      puts "Please try again."
      puts ""
      get_beers
    end

  end

  def list_beers
    if WhatsOnTap::Beer.all.empty?
      puts " There is no individual beer data for this location. Please try again."
      puts ""
      restart_from_location_list
    else
      WhatsOnTap::Beer.all.each.with_index(1) do |beer_object, i|
        puts " #{i}. #{beer_object.name}"
      end
    end
  end

  def get_a_beer_and_list_details
    puts ""
    puts "Enter the number of a beer you'd like to learn more about. You can also type 'list' to see the list of locations again, type 'back' to start over, or type 'exit' to exit."
    puts ""

    beer_input = gets.strip
    if beer_input.to_i > 0 && beer_input.to_i <= WhatsOnTap::Beer.all.size
      beer_number = beer_input.to_i - 1
      WhatsOnTap::Scraper.get_beer_info_page(beer_number)

      beer_object = WhatsOnTap::Scraper.get_and_set_beer_attributes(beer_number)
      # beer_object = WhatsOnTap::Beer.all[beer_number]
      puts ""
      puts "#{beer_object.name}"
      puts "#{"-" * (beer_object.name.length + 2)}"
      puts "Brewery: #{beer_object.brewery}"
      puts "Brewery Location: #{beer_object.brewery_location}"
      puts "Type: #{beer_object.type}"
      puts "ABV: #{beer_object.abv}"
      puts "Description: #{beer_object.full_description}"
      puts ""
    elsif beer_input.downcase == "exit"
      exit
    elsif beer_input.downcase == "back"
      puts ""
      get_locations
      restart_from_location_list
    elsif beer_input.downcase == "list"
      restart_from_location_list
    else
      puts ""
      puts "Please try again."
      puts ""
      get_a_beer_and_list_details
    end
  end #end of get_a_beer_and_list_details

  def restart_or_exit
    puts "What would you like to do next? Choose one of the following:"
    puts ""
    puts "     Enter 'beers' to see the  beer list for this location again."
    puts "     Enter 'list' to see the previous list of locations for this city."
    puts "     Enter 'restart' to start over with a different city."
    puts "     Enter 'exit' to exit."
    puts ""

    input = gets.strip.downcase
    case input
    when "beers"
      puts ""
      list_beers
      get_a_beer_and_list_details
      restart_or_exit
    when "list"
      puts ""
      restart_from_city
    when "restart"
      puts ""
      restart_after_welcome
    when "exit"
      goodbye
      exit
    else
      puts ""
      puts "Please enter a valid input."
      puts ""
      restart_or_exit
    end
  end

  def goodbye
    puts ""
    puts "Until next time, happy drinking!"
  end

  ###########################  helper methods #################################

  def restart_from_location_list
    list_locations
    get_beers
    list_beers
    get_a_beer_and_list_details
  end

  def restart_from_city
    list_locations
    get_beers
    list_beers
    get_a_beer_and_list_details
    restart_or_exit
  end

  def restart_after_welcome
    get_locations
    list_locations
    get_beers
    list_beers
    get_a_beer_and_list_details
    restart_or_exit
    goodbye
  end
end
