require 'pry'
require 'colorize'

class JazzNyc::CLI

  def call
    SmallsScraper.scrape  #call all scrapers here
    VanScraper.scrape
    Event.sort # put after the scrapers to make sure Event class is organized by date, then venue
    puts ""
    puts "      -----------------------------------------"
    puts ""
    puts "      W E L C O M E    T O    J A Z Z    N Y C!"
    puts ""
    puts "      -----------------------------------------"
    puts ""
    puts "                 Today is #{DateTime.now.strftime('%m/%d/%Y')}"
    Menu.home 
  end
end


