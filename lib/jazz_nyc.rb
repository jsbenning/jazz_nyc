require_relative "./jazz_nyc/version"
require_relative "./jazz_nyc/cli"

require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper
  attr_accessor :small_events, :time, :group, :artists, :art_list

 


  def self.scrape_smalls
    small_events = Hash.new


    page = Nokogiri::HTML(open("https://www.smallslive.com/events/calendar/")) 
    page.css("div[class='day flex col-xs-6 col-md-3']").each do |e|
      
      time = []
      group = []
      small_events[:venue] = "Small's"
      small_events[:day] = e.css("h2").text
      e.css("dd").css("a").each{|e| group << e.text}



      e.css("dt").each{|e| time << e.text}
      show = group.zip( time )        
      small_events[:shows] =  show

      Menu.new(small_events)

    end
  end


end

#Scraper.scrape_smalls

class Menu
  attr_accessor :venue, :day, :shows

  @@all = []

  def initialize(hash)
    hash.each do |k, v|
      self.send "#{k}=", v
    end
    @@all << self
  end

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end

  def self.output
    @@all.each{|e| puts e}
  end

  def self.day
    puts "What day would you like to check?"
    puts "1 = Sun, 2= Mon, 3 = Tue, 4 = Wed, 5 = Thu, 6 = Friday, 7 = Sat"
    input = gets.chomp
    @@all.each do |e|
    end
  end
      


  def self.shows
    @@all.each do |e|
      puts e.day
      puts "---------------------"
      puts " "
      puts "     " + e.shows
      puts " "

    end
  end

end


