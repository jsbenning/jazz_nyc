class Scraper
  attr_accessor :events
  #venue, day, date, time=array, group=array, bio=array -- only Smalls currently

  def self.smalls_scraper
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

  def self.van_scraper
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
      events[:time] =  e.css("p[id='event-time']").map{|x| x.text} 
      events[:group] = e.css("h1[id='event-title']").map{|x| x.text}
      events[:bio] = []
      Event.new(events)
    end
  end
end


class Test
  attr_accessor :events

  require 'nokogiri'
  require 'open-uri'

  def self.bird_scraper
    events = Hash.new
    events[:testr] = "Crap"
    page = Nokogiri::HTML(open("http://www.birdlandjazz.com/listing/"))
    page.css('div.tfly-venue-id-973').each do |e|
      events[:venue] = "Birdland"
      show = e.css("div[class='list-view-details vevent']")
      events[:group] = show.css("h1[class='headliners summary']").text
      if e.css('div.event-group-times')
        group_shows = e.css('div.event-group-times')
        events[:day] = group_shows.css('.date-time').text[0...3]
        events[:date] = group_shows.css("h3[class='date-time']").text.slice(5..-2)
        events[:time] = group_shows.css("h3[class='date-time']").css("a").map{|x| x.text}
      else
        events[:day] = show.css("h2[class='dates']").text[0...3]
        events[:date] = show.css("h2[class='dates']").text.slice(5..-1)
        events[:time] = Array.new.push(show.css("h2[class='times']").css('span').text)
      end    
    end
    events
  end

end





      # if e.css("div[class='list-view-details vevent']")
      # single_show = e.css("div[class='list-view-details vevent']")
      #   single_show.each do |s|
      #   # if s.css("h2[class='dates']")
      #   #   events[:venue] = "Birdland"
      #   #   events[:day] = s.css("h2[class='dates']").text[0...3]
      #   #   events[:date] = s.css("h2[class='dates']").text.slice(5..-1)
      #   #   events[:time] = Array.new.push(s.css("h2[class='times']").css('span').text)
      #   if s.css("h3[class='date-time']")
      #     events[:venue] = "Birdland"
      #     events[:day] = e.css("h3[class='date-time']").text[0...3]
      #     events[:date] = e.css("h3[class='date-time']").text.slice(5..-2)
      #     events[:time] = e.css("h3[class='date-time']").css("a").map{|x| x.text}
      #   end
      # end 



      # if e.css("[class='date-time']")
      #   events[:existence] = true
      #   events[:venue] = "Birdland"
      #   events[:day] = e.css("h3[class='date-time']").text[0...3]
      #   events[:date] = e.css("h3[class='date-time']").text.slice(5..-2)
      #   events[:time] = e.css("h3[class='date-time']").css("a").text
      #end 
      #else















