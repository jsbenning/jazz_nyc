#require 'pry'
require 'colorize'

class Event
  attr_accessor :venue, :day, :date, :time, :group, :bio

  VENUES = [["Small's", "183 W. 10th St.", "Greenwich Village", "smallslive@gmail.com"],
  ["The Village Vanguard", "178 7th Ave South", "Greenwich Village", "(212)255-4037", "villagevanguard.com"]] #venues should be added here in arrays

  @@all = []

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end

  def self.sort
    Event.all.sort_by!{|event| [event.date, event.venue]}
  end

  def initialize(hash)
    hash.each do |k, v|
      self.send "#{k}=", v
    end
    @@grouper = [] #initializes an array for sorting events
    @@all << self
  end

  def self.complete_list
    Event.all.each do |event| 
      Event.printer(event)
    end
    Event.jump
  end

  def self.jump
    @@grouper.clear
    JazzNyc::CLI.call
  end

  def self.printer(event)
    @date = " #{event.date} " #ensures that date only prints once
    @id = " #{event.date} #{event.venue}" #ensures that venue only prints once per date
    if !(@@grouper.include?(@date))
      puts "#{event.day}" + " " + "#{event.date}"
      puts "---------------------"    
      puts ""
      @@grouper << @date
    end
    if !(@@grouper.include?(@id))
      puts ("    " + "#{event.venue}" + ":").colorize(:blue)
      puts ""
      @@grouper << @id
    end
    @show = event.time.zip(event.group)
    @show.sort do |a, b|
      a[0] <=> b[0]
    end
    @show.each do |time, group|
      puts (time + " - " + group).colorize(:red)
    end
    puts ""
    @show.clear 
  end

  def self.list_venue(input)
    @count = 0
    VENUES.each do |venue|
      if venue[0].downcase.include?(input.downcase[0..-2])
        puts ""
        puts venue
        puts ""
        @count += 1
        puts "Would you like to check out upcoming shows just for this venue?(y/n)"
        @answer = gets.downcase.strip
        if @answer == "y"
          Event.all.each do |event|
            if event.venue.downcase.include?(input.downcase[0..-2])
            Event.printer(event)
            end
          end
        else
          Event.jump
        end
      end
    end
    if @count == 0
      puts "Sorry, I don't have any information about that venue.".colorize(:red)
    end
    Event.jump   
  end

  def self.date_search(day)
    @count = 0 
    @date_split = day.split("/")
    Event.all.each do |event|
      event_date = event.date.split("/") 
      if @date_split[0] == event_date[0] && (@date_split[1] == event_date[1] || ("0" + @date_split[1]) ==  event_date[1]) 
        @count += 1
        Event.printer(event)
      end   
    end
    if @count == 0
      puts "Sorry, I couldn't find a matching date.".colorize(:red)
    end
    Event.jump
  end

  def self.day_search(day)
    @count = 0
    @days = %w(mon tue wed thu fri sat sun) 
    if @days.include?(day.downcase[0..2])
      @day = day.downcase[0..2]
      Event.all.each do |event| 
        if @day.capitalize == event.day
          @count += 1
          Event.printer(event)
        end
      end
    end
    if @count == 0
      puts "Sorry, I could't find a matching day.".colorize(:red) 
    end
    Event.jump
  end

  def self.keyword_search(keyword)
    @count = 0
    Event.all.each do |event|
      event.group.each do |performer|
        if performer.include?(keyword) || performer.downcase.include?(keyword.downcase)
          @count += 1

          Event.printer(event)
        end
      end
    end
    if @count == 0
      puts "Sorry, I couldn't find a keyword or performer that matched.".colorize(:red)
    end 
    Event.jump 
  end

  def self.bio_search(input)
    @count = 0
    Event.all.each do |event|
      event.bio.each do |link|
        @search_term = link.split("-")
        @search_term.join("")
        if @search_term.include?(input)
          @count += 1
          self.profile("https://www.smallslive.com" + (link)) 
        end  
      end
    end
    if @count == 0
      puts ""
      puts "Sorry, we don't have any info about that artist.".colorize(:red)
      puts ""
    end
    Event.jump
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
    Event.jump
  end

end