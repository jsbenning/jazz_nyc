class JazzNyc::Menu
  attr_accessor :venue, :day, :shows, :bio

  @@all = []

  def initialize(hash)
    hash.each do |k, v|
      self.send "#{k}=", v
    end
    @@all << self
  end

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end

  def self.home

    puts " "
    puts "What would you like to do now?".colorize(:red)
    puts " "
    puts "1 = See All Shows, 2 = Look at Biographies, 3 = Sort Shows by Day, 4 = Get Venue Info, 5 = Exit".colorize(:blue)
    puts " "
    input = gets.chomp
    case input
    when "1"
      self.shows
    when "2"
      self.bio
    when "3"
      self.day
    when "4"
      self.location
    when "5"
      self.clear
      puts ""
      puts "See you at the shows, Jazz Fans!".colorize(:red)
      puts "Thanks!".colorize(:red)
      puts ""
      exit
    end
  end
          


  def self.day
    puts "What day would you like to check?".colorize(:red)
    puts " "
    puts "1 = Sun, 2 = Mon, 3 = Tue, 4 = Wed, 5 = Thu, 6 = Fri, 7 = Sat".colorize(:blue)
    input = gets.chomp
    case input
    when "1"
      x = "Sunday"
    when "2"
      x = "Monday"
    when "3"
      x = "Tuesday"
    when "4"
      x = "Wednesday"
    when "5"
      x = "Thursday"
    when "6"
      x = "Friday"
    when "7"
      x = "Saturday"          
    else
      puts "Sorry, that's not a choice...".colorize(:red)
      self.home
    end
    @@all.each do |e|
      if e.day[x]
        puts " "
        puts e.day.colorize(:red)
        puts "---------------------".colorize(:red)
        puts " "
        puts e.shows
        puts " "
      end
    end
    self.home
  end

     
  def self.location
    x = 0
    @@all.each do |e|
      while x < 1
        puts " "
        puts e.venue[0].colorize(:red)
        puts e.venue[1]
        puts e.venue[2]
        puts e.venue[3]
        puts " " 
        x += 1
      end
      self.home
    end 
  end

  def self.artists
    artist_list = []
    @@all.each do |e|
      e.shows.each{|e| artist_list << e[0]}
    end
    artist_list.each{|artist| puts artist.colorize(:blue)}
  end

  def self.shows
    @@all.each do |e|
      puts e.day.colorize(:red)
      puts "---------------------".colorize(:red)
      puts " "
      puts e.shows
      puts " "
    end
    self.home
  end

  def self.bio
    count = 0
    puts " "
    puts " "
    puts "Here are all the current performers: ".colorize(:red)
    puts " "
    self.artists
    puts " "
    puts "Who would you like to know more about?".colorize(:red)
    puts "(Enter the first ".colorize(:blue) + "OR ".colorize(:red) + "last name for artist & group info)".colorize(:blue)
    input = gets.downcase.strip
    @@all.each do |e|
      e.bio.each do |link|
        x = link.split("-")
        x.join("")
        if x.include?(input)
          count += 1
          self.profile("https://www.smallslive.com/" + (link)) 
        end  
      end
    end
    if count == 0
      puts ""
      puts "Sorry, we don't have any info about that artist.".colorize(:red)
      puts ""
    end
    self.home
  end



  def self.profile(link)
    band = []
    page = Nokogiri::HTML(open(link))
    page.css("div[class ='mini-artist col-xs-12 col-sm-6']").each do |e|
      e.css("a").each do |link|
        band << "https://www.smallslive.com" + (link.attribute("href").value.to_s)
      end
    end
    band = band.uniq
    band.each do |member|
      page = Nokogiri::HTML(open(member))
      puts " "
      puts page.css("h1[class='artist-details__name']").text
      puts " "
      puts page.css("div[class='artist-bio__text-block']").css("p").text
    end
    self.home
  end
 

  
end
