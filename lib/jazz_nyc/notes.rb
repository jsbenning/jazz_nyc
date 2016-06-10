class JazzNyc::Scraper
  attr_accessor :small_events


  def self.scrape_smalls
    small_events = Hash.new


    page = Nokogiri::HTML(open("https://www.smallslive.com/events/calendar/")) 


    page.css("div[class='day flex col-xs-6 col-md-3']").each do |e|
      

      small_events[:venue] = ["Small's", "183 W. 10th St.", "Greenwich Village", "smallslive@gmail.com"]

      small_events[:day] = e.css("h2").text

      group = e.css("dd").css("a").map{|e| e.text}

      # 1 store the results in a rray
      # 2 call #length
      # push that leng in




      time = e.css("dt").map{|e| e.text}
      show = group.zip( time )        
      bio = e.css("dd").css("a").map{|e| e.attribute("href").value}
      small_events[:shows] =  show
      small_events[:bio] = bio
      # JazzNyc::Menu.new(small_events)
      # reification 
      Event.new({:venue => Smalls, :performer => "Kermit"}

    end
  end


end)