require 'pry'
require 'colorize'

class JazzNyc::Event
  attr_accessor :venue, :day, :date, :time, :group

  VENUES = VENUES = [["Small's", "183 W. 10th St.", "Greenwich Village", "smallslive@gmail.com"],
  ["The Village Vanguard", "178 7th Ave South", "Greenwich Village", "(212)255-4037", "villagevanguard.com"]] #venues should be added here in arrays

  @@all = []

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end

  def initialize(hash)
    hash.each do |k, v|
      self.send "#{k}=", v
    end
    @@headline = []
    @@all << self
  end

  def self.headline
    @@headline 
  end

  def self.headline_clear
    @@headline = []
  end

  def self.formatting(event)
    if Event.headline == []
      Event.headline << event
    elsif !(Event.headline.include?(event)) &&  Event.headline.first.date == event.date
      Event.headline << event
    else 
      puts "#{Event.headline.first.day}  #{Event.headline.first.date}"
      puts "--------------------------------"   
      Event.headline.sort_by!{ |a| a.venue}
      @venue_list = []
      Event.headline.each do |event|
        if !(@venue_list.include?(event.venue))
          @venue_list << event.venue
          puts ("    " + event.venue + ":").colorize(:blue)
        end
        @shows = event.time.zip(event.group).each{|time, group|}
          @shows.each do |time, group|
          puts (time + " - " + group).colorize(:red)
        end
      end
      puts ""
      Event.headline_clear
      @venue_list = []
      Event.formatting(event)
    end
  end


  def self.complete_list 
    @sorted = Event.all.sort_by{|event| event.date}
    @sorted.each do |event|
      Event.formatting(event)
    end
    Event.headline_clear
    Menu.home
  end

  def self.select_list(event)
    @event = event
    puts @event.day + " " + @event.date
    puts "---------------------"
    puts ("    " + @event.venue + ":").colorize(:blue)
    @event.time.zip(@event.group).each do |time, group|
        puts (time + " - " + group).colorize(:red)
    end
     puts ""
  end

  def self.select_group(event, performer)
    @event = event
    @performer = performer
    puts @event.day + " " + @event.date
    puts "---------------------"
    puts ("    " + @event.venue + ":").colorize(:blue)
    @event.time.zip(@event.group).each do |time, group|
      if group == @performer
        puts (time + " - " + group).colorize(:red)
      end
    end
    puts ""
  end

  def self.list_venue(input)
    @count = 0
    @input = input
    VENUES.each do |venue|
      if venue[0].downcase.include?(@input.downcase[0..-3])
        puts ""
        puts venue
        puts ""
        @count += 1
        Menu.home
      end
    end
    if @count == 0
      puts "Sorry, we don't have any information about that venue.".colorize(:red)
    Menu.home  
    end   
  end


  def self.date_search(day)
    @count = 0
    @date = day.split("/")
    Event.all.each do |event|
      @event_date = event.date.split("/") 
      if @date[1] == @event_date[1] && @event_date[0].include?(@date[0])
        @count += 1
        Event.select_list(event)
      end
    end
    if @count == 0
      puts "Sorry, I can't find a date like that.".colorize(:red)
    end
    Menu.home
  end

  def self.day_search(day)
    @count = 0
    @day = day.downcase[0..2]
    days = %w(mon tue wed thu fri sat sun)
    if days.include?(@day)
      Event.all.each do |event| 
        if @day.capitalize == event.day
          @count += 1
          Event.select_list(event)
        end
      end  
      if @count == 0
        puts "Sorry, I can't find a day like that.".colorize(:red) 
      end
    end
    Menu.home
  end

  def self.keyword_search(keyword)
    @keyword = keyword
    @count = 0
    Event.all.each do |event|
      event.group.each do |performer|
        if performer.downcase.include?(@keyword.downcase)
          @count += 1
          Event.select_group(event, performer)
        end
      end
    end
    if @count == 0
      puts "Sorry, I can't find a keyword or performer with that name.".colorize(:red)
    end 
    Menu.home  
  end
  
end
