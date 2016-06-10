require 'nokogiri'
require 'open-uri'

class Scraper
  attr_accessor  :van_events


  def self.vanguard_scraper
    
    van_events = Hash.new

    page = Nokogiri::HTML(open("http://www.instantseats.com/index.cfm?fuseaction=home.venue&VenueID=1&sid=3"))

    page.css("div[class='row']").each do |e|
      van_events[:venue] = "The Village Vanguard"
      van_events[:day] = e.css("div[class='event-mobile-info']").css("p[id='event-date']").first.text || "Sorry, no info"
      van_events[:shows]  = e.css("h1[id='event-title']").first.text || "Sorry, no info"
      van_events[:time] =  e.css("div[class='event-mobile-info']").css("p[id='event-time']").first.text || "Sorry, no info"
      van_events[:price] =  e.css("p[id='event-price']").first.text || "Sorry, no info"  
      #Menu.new(van_events)
      van_events.each{|k,v| puts "#{k} : #{v}"}
    end
    #van_events.each{|k,v| puts "#{k} : #{v}"}
  end

end

#Scraper.vanguard_scraper

class Menu
  attr_accessor :venue, :day, :shows, :bio

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

  def self.home

    puts " "
    puts "What would you like to do now?"
    puts " "
    puts "1 = See All Shows, 2 = Look at Biographies, 3 = Sort Shows by Day, 4 = Get Venue Info, 5 = Exit"
    puts " "
    input = gets.chomp
    case input
    when "1"
      self.shows
    when "2"
      self.bio
    when "3"
      self.day
    when "4"
      self.location
    when "5"
      self.clear
      puts ""
      puts "See you at the shows, Jazz Fans!"
      puts "Thanks!"
      puts ""
      exit
    end
  end
          


  def self.day
    puts "What day would you like to check?"
    puts " "
    puts "1 = Sun, 2 = Mon, 3 = Tue, 4 = Wed, 5 = Thu, 6 = Fri, 7 = Sat"
    input = gets.chomp
    case input
    when "1"
      x = "Sunday"
    when "2"
      x = "Monday"
    when "3"
      x = "Tuesday"
    when "4"
      x = "Wednesday"
    when "5"
      x = "Thursday"
    when "6"
      x = "Friday"
    when "7"
      x = "Saturday"          
    else
      puts "Sorry, that's not a choice..."
      self.home
    end
    @@all.each do |e|
      if e.day[x]
        puts " "
        puts e.day
        puts "---------------------"
        puts " "
        puts e.shows
        puts " "
      end
    end
    self.home
  end

     
  def self.location
    x = 0
    @@all.each do |e|
      while x < 1
        puts " "
        puts e.venue[0]
        puts e.venue[1]
        puts e.venue[2]
        puts e.venue[3]
        puts " " 
        x += 1
      end
      self.home
    end 
  end

  def self.artists
    artist_list = []
    @@all.each do |e|
      e.shows.each{|e| artist_list << e[0]}
    end
    artist_list.each{|artist| puts artist}
  end

  def self.shows
    @@all.each do |e|
      puts e.day
      puts "---------------------"
      puts " "
      puts e.shows
      puts " "
    end
    self.home
  end

  def self.bio
    count = 0
    puts " "
    puts " "
    puts "Here are all the current performers: "
    puts " "
    self.artists
    puts " "
    puts "Who would you like to know more about?"
    puts "(Enter the first "+ "OR " + "last name for artist & group info)"
    input = gets.downcase.strip
    @@all.each do |e|
      e.bio.each do |link|
        x = link.split("-")
        x.join("")
        if x.include?(input)
          count += 1
          self.profile("https://www.smallslive.com/" + (link)) 
        end  
      end
    end
    if count == 0
      puts ""
      puts "Sorry, we don't have any info about that artist."
      puts ""
    end
    self.home
  end



  def self.profile(link)
    band = []
    page = Nokogiri::HTML(open(link))
    page.css("div[class ='mini-artist col-xs-12 col-sm-6']").each do |e|
      e.css("a").each do |link|
        band << "https://www.smallslive.com" + (link.attribute("href").value.to_s)
      end
    end
    band = band.uniq
    band.each do |member|
      page = Nokogiri::HTML(open(member))
      puts " "
      puts page.css("h1[class='artist-details__name']").text
      puts " "
      puts page.css("div[class='artist-bio__text-block']").css("p").text
    end
    self.home
  end
 

  
end


#Scraper.vanguard_scraper




                                  <div class="row">
                                        <div class="large-1 column hide-for-small">
                                            <div class="event-date">
                                                <p id="dow">Fri</p>
                                                <p id="event-date">05.13</p>
                                            </div>
                                        </div>
                                        <div class="large-8 columns">

                                            <div class="image-resize">

                                                <img class="event-photo-th" src="/photos/SteveColeman.jpg">

                                            </div>
                                            <h1 id="event-title">Steve Coleman & Five Elements</h1>
                                            <p class="secondary"></p>
                                            <span class="hide-for-small"><a href="index.cfm?fuseaction=home.event&eventID=9AE5DA5B-9D5E-68E3-6FDF7E5B06CCA8BA" class="tiny button">Event Info</a></span>
                                        </div>
                                        <div class="large-3 columns">
                                            <div class="event-buying-info">
                                                <div class="event-mobile-info">

                                                    <span class="radius label">Online sales closed. Call the club (212) 255-4037</span>
                                                    <p id="event-date" class="show-for-small">Friday, May 13</p>
                                                    <p id="event-price">$30 | $3 Fees</p>
                                                    <p id="event-time">8:30 PM</p>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
