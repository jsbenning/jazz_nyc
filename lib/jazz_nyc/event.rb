require 'pry'
require 'colorize'

class JazzNyc::Event
  attr_accessor :venue, :day, :date, :time, :group

  VENUES = [["Small's", "183 W. 10th St.", "Greenwich Village", "smallslive@gmail.com"]] #venues should be added here in arrays

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
    @head = "#{event.date} #{event.venue}"
    if !(Event.headline.include?(event.date))
      Event.headline << event.date
      puts "#{event.day}   #{event.date}"
      puts "--------------------------------" 
    end
    if !(Event.headline.include?(@head)) 
      Event.headline << @head    
      puts ("    " + event.venue + ":").colorize(:blue)
    end
    puts ""
    @shows = event.time.zip(event.group).each{|time, group|}
    @sorted_shows = @shows.sort do |a,b|
      a[0].to_i <=> b[0].to_i
    end
    if @sorted_shows[0][0].include?("AM")
      @sorted_shows.rotate!(1)
    end
      @sorted_shows.each do |time, group|
      puts (time + " - " + group).colorize(:red)
      puts ""
    end
  end

  def self.complete_list  
    #Event.all.each do |event|
    @sorted = Event.all.sort_by{|event| event.date}
    @sorted.each do |event|
      Event.formatting(event)
    end
    Event.headline_clear
    Menu.home
  end

  def self.select_list(event)
    @event = event
    puts ""
    puts @event.day + " " + @event.date
    puts "---------------------"
    puts "    " + @event.venue + ":"
    puts ""
    @event.time.zip(@event.group).each do |time, group|
        puts time + " - " + group
    end
  end

  def self.select_group(event, performer)
    @event = event
    @performer = performer
    puts ""
    puts @event.day + " " + @event.date
    puts "---------------------"
    puts "    " + @event.venue + ":"
    puts ""
    @event.time.zip(@event.group).each do |time, group|
      if group == @performer
        puts time + " - " + group
      end
    end
  end

  def self.list_venue(input)
    @count = 0
    @input = input
    VENUES.each do |venue|
      venue.each do |v| 
        if v.downcase.include?(@input.downcase[0..-3])
          puts ""
          puts venue
          puts ""
          @count += 1
          Menu.home
        end
        if @count == 0
          puts "Sorry, we don't have any information about that venue."
          Menu.home
        end
      end
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
      puts "Sorry, I can't find a date like that."
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
        puts "Sorry, I can't find a day like that." 
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
      puts "Sorry, I can't find a keyword or performer with that name."
    end 
    Menu.home  
  end
  
end