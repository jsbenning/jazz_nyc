class JazzNyc::Scraper
  attr_accessor :small_events


  def self.scrape_smalls
    small_events = Hash.new


    page = Nokogiri::HTML(open("https://www.smallslive.com/events/calendar/")) 


    page.css("div[class='day flex col-xs-6 col-md-3']").each do |e|
      
      time = []
      group = []
      bio = []
      small_events[:venue] = ["Small's", "183 W. 10th St.", "Greenwich Village", "smallslive@gmail.com"]
      small_events[:day] = e.css("h2").text
      e.css("dd").css("a").each{|e| group << e.text}
      e.css("dt").each{|e| time << e.text}
      show = group.zip( time )        
      e.css("dd").css("a").each{|e| bio << e.attribute("href").value}
      small_events[:shows] =  show
      small_events[:bio] = bio
      JazzNyc::Menu.new(small_events)

    end
  end


end