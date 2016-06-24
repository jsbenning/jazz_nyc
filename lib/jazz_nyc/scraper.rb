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