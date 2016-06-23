require 'pry'
require 'colorize'

class JazzNyc::Event
require 'pry'
require 'colorize'

class Event
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

  def self.sort
    Event.all.sort_by!{|event| [event.date, event.venue}
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
    Menu.home
  end

  def self.printer(event)
    @date = " #{event.date} "
    @id = " #{event.date} #{event.venue}"
    if !(@@grouper.include?(@date))
      puts event.day + " " + event.date
      puts "---------------------"
      puts ""
    end
    if !(@@grouper.include?(@id))
      puts ("    " + event.venue + ":").colorize(:blue)
      puts ""
    end
    @show = event.time.zip(event.group)
    @show.sort do |a, b|
      a[0] <=> b[0]
    end
    @show.each do |time, group|
      puts (time + " - " + group).colorize(:red)
    end
    puts ""
    @@grouper << @date
    @@grouper << @id
  end

  def self.list_venue(input)
    @count = 0
    VENUES.each do |venue|
      if venue[0].downcase.include?(input.downcase[0..-3])
        puts ""
        puts venue
        puts ""
        @count += 1
        puts "Here are some upcoming performances at that venue:"
      end
      Event.all.each do |event|
        if event.venue.downcase.include?(input.downcase[0..-3])
          Event.printer(event)
        end
      end
    end
    if @count == 0
      puts "Sorry, we don't have any information about that venue.".colorize(:red)
    end
    Event.jump   
  end

  def self.date_search(day)
    @count = 0 
    @date = day.split("/")
    Event.all.each do |event|
      @event_date = event.date.split("/") 
      if @date[0] == @event_date[0] && @event_date[1] == ((@date[1]) || ("0" + @date[1]))
        @count += 1
        Event.printer(event)
      end   
    end
    if @count == 0
      puts "Sorry, I couldn't find a date that matched.".colorize(:red)
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
      puts "Sorry, I could't find a day that matched.".colorize(:red) 
    end
    Event.jump
  end

  def self.keyword_search(keyword)
    @count = 0
    Event.all.each do |event|
      event.group.each do |performer|
        if performer.include?(keyword[0..-3] || keyword.downcase[0..-3] || keyword.capitalize[0..-3])
          Event.printer(event)
        end
      end
    end
    if @count == 0
      puts "Sorry, I couldn't find a keyword or performer that matched.".colorize(:red)
    end 
    Event.jump 
  end

end
