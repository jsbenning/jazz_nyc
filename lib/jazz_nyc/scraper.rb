class Scraper
  attr_accessor :events
  #venue, day, date, time=array, group=array, bio=array -- only Smalls currently

  def self.start
    self.smalls_scraper
    self.van_scraper
    self.bird_scraper
  end

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


  def self.bird_scraper
    events = Hash.new
    
    page = Nokogiri::HTML(open("http://www.birdlandjazz.com/listing/"))
    page.css('div.tfly-venue-id-973').each do |e|
      events[:venue] = "Birdland"
      show = e.css("div[class='list-view-details vevent']")
      group_arr = []
      group_name = (show.css("h1[class='headliners summary']").text)
      if !(e.css('div.event-group-times')).empty?
        group_shows = e.css('div.event-group-times')
        long_day = group_shows.css('.date-time').text.split
        events[:day] = long_day[0].gsub!(".", "")
        month = long_day[1].downcase
        new_month = self.standardize_month(month)
        events[:date] = (new_month + long_day[2]).gsub!(":", "")
        events[:time] = group_shows.css('.date-time').css("a").map{|x| x.text}
        (events[:time].length).times{ group_arr.push(group_name) }
        events[:group] = group_arr
        events[:bio] = []
        Event.new(events)
      else
        events[:day] = show.css('.dates').text[0...3]
        month = show.css('.dates').text.slice(5..-1).split[0].downcase
        date = show.css('.dates').text.slice(5..-1).split[1]
        if date.length == 1
          new_date = "0" + date 
        else 
          new_date = date
        end 
        new_month = self.standardize_month(month)
        events[:date] = new_month + new_date
        events[:time] = Array.new.push(show.css('.times').css('span').text)
        events[:group] = group_arr.push(group_name)
        events[:bio] = []
        Event.new(events)
      end    
    end
  end

  def self.standardize_month(month)
    case month
    when "january"
      "1/"
    when "february"
      "2/"
    when "march"
      "3/"
    when "april"
      "4/"
    when "may"
      "5/"
    when "june"
      "6/"
    when "july"
      "7/"
    when "august"
      "8/"
    when "september"
      "9/"
    when "october"
      "10/"
    when "november"
      "11/"
    when "december"
      "12/"
    else
      "huh?" 
    end               
  end
  
end




