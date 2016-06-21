require 'pry'
require 'colorize'

class JazzNyc::CLI

  def call
    SmallsScraper.scrape  #call all scrapers here
    puts "--------------------"
    puts ""
    puts "Welcome to Jazz NYC!"
    puts ""
    puts "--------------------"
    Menu.home 
  end
end

