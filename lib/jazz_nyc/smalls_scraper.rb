require 'pry'
require 'nokogiri'
require 'open-uri'
require 'colorize'

class JazzNyc::SmallsScraper
  attr_accessor :events

  def self.scrape
    events = Hash.new
    page = Nokogiri::HTML(open("https://www.smallslive.com/events/calendar/"))
    page.css("div[class='day flex col-xs-6 col-md-3']").each do |day|
      events[:venue] = "Smalls"
      events[:day] = day.css("h2").text[0...3]
      @my_date = day.css("h2").text.split(" ")[1].split("/")
      if @my_date[1].length == 1
        events[:date] = @my_date[0] + "/" + "0" + @my_date[1]
      else
        events[:date] = @my_date[0] + "/" + @my_date[1]
      end
      events[:time] = day.css("dt").map{|x| x.text.split(" - ")[0]}
      events[:group] = day.css("dd").css("a").map{|x| x.text}
      events[:bio] = day.css("dd").css("a").map{|x| x['href']}
      Event.new(events)
    end
  end

