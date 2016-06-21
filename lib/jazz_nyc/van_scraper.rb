require 'pry'
require 'nokogiri'
require 'open-uri'


class JazzNyc::VanScraper
  attr_accessor  :events

  def self.scrape
    
    events = Hash.new

    page = Nokogiri::HTML(open("http://www.instantseats.com/index.cfm?fuseaction=home.venue&VenueID=1&sid=3"))

    page.css("div[class='event-link-mobile']").each do |e|
      events[:venue] = "The Village Vanguard"
      events[:day] = e.css("p[id='dow']").text
      @my_date =  e.css("p[id='event-date']").text[0...5].gsub!(".","/")
      if @my_date[0] == "0"
        @my_date = @my_date[1..-1]
      end
      events[:date] = @my_date  
      events[:group] = e.css("h1[id='event-title']").map{|x| x.text}
      events[:time] =  e.css("p[id='event-time']").map{|x| x.text}
      Event.new(events)
    end
  end
end