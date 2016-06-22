require 'pry'
require 'colorize'

class JazzNyc::CLI

  def call
    SmallsScraper.scrape  #call all scrapers here
    VanScraper.scrape

    puts ""
    puts "      -----------------------------------------"
    puts ""
    puts "      W E L C O M E    T O    J A Z Z    N Y C!"
    puts ""
    puts "      -----------------------------------------"
    
    Menu.home 
  end
end


