class WhatsOnTap::Scraper


  def self.get_beer_menu_page(city)
    @@page = Nokogiri::HTML(open("https://www.beermenus.com/search?q=#{city}"))
  end

  def self.page
    @@page
  end

  def self.beer_page
    @@beer_page
  end

  def self.scrape_locations
    locations = self.page.css("h3.mb-0.text-normal a").take(5).map {|p| p.text}

  end

  def self.scrape_establishment_type
    establishment_type = self.page.css("h3.mb-0.text-normal span").take(6).map {|p| p.text.gsub("· ", "")}
  end

  def self.scrape_num_beers_on_tap
    num_beers_on_tap = self.page.css("p.caption.text-gray.mb-small").take(6).map {|p| p.text}
    # binding.pry
  end

  def self.scrape_location_url
    url = self.page.css("h3.mb-0.text-normal a").take(5).map { |link| link['href']}
  end

  def self.get_beer_list_page(place)
    modified_url = "https://www.beermenus.com#{self.scrape_location_url[place]}"
    @@beer_page = Nokogiri::HTML(open(modified_url))
  end

  def self.scrape_beers
    beer_list = self.beer_page.css("h3.mb-0.text-normal a").take(10).map {|p| p.text}
    # binding.pry
  end

  # def self.get_beer_data_page(beer)
  #   modified_beer_url = "https://www.beermenus.com#{self.scrape_location_url[beer]}"
  #   @@beer_page = Nokogiri::HTML(open(modified_beer_url))
  # end

  # def self.scrape_individual_beer_data
  #     brewery = self.beer_page.css("div.pur-f-body a")
  #     brewery_location = self.beer_page.css("p.mt-tiny.mb-0")
  #     type_and_abv = self.beer_page.css("span.pure-icon-info p")
  #     notes = self.beer_page.css("div.caption p")
  #     description = self.beer_page.css("div.caption.beer-desc p")
  # end

end

#1. Class needs to instantiate new locations based on zip
#2. Scrape the location website for beer lists  ##and also scrape for beer details here?
#https://www.beermenus.com/places
#I'm not sure how to get this to pull up with the zip I want, which is all I need for now. Will ultimately want to be able to
#modiy based on the user inputted zip but will cross that bridge when I get to it
#I mostly just want to scrape bars and restaurants, places with multiple beers actually on tap. I guess I'm okay
# stores if it is also a sit down place and has >= 1 beer on tap
#maybe only give users 5 locations at a time



#3. Instantiate new beer objects
#4. and do what? scrape individual beer websites to get details and add those to beer objects? Or do I just get those details while scraping
#for the beer

#should not need class method here?
