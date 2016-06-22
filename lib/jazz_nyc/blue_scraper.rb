class BlueScraper
  require 'nokogiri'
  require 'open-uri'
  attr_accessor :events

  #venue, day, date, group=array, time=array

    def self.scrape
    events = Hash.new
    page = Nokogiri::HTML(open("http://www.bluenote.net/newyork/schedule/index.shtml"))
    page.css("center").each do |day|
      events[:venue] = "Blue Note"
      events[:group] = day.css("td[class='show']").css("p").each{|e| e.text}

      events[:time] = day.css("dt").map{|x| x.text}

      #events[:day] = day.css("h2").text
        #events[:time] = day.css("dt").map{|x| x.text}
        #events[:group] = day.css("dd").css("a").map{|x| x.text}
      Event.new(events)

    end
  end
end


class Event
  attr_accessor :venue, :day, :time, :group

  @@all = []

  def self.all
    @@all
  end

  def initialize(hash)
    hash.each do |k, v|
      self.send "#{k}=", v
    end
    @@all << self
  end

  def self.clear
    @@all.clear
  end 
end

#BlueScraper.scrape