class JazzNyc::CLI  

  def welcome
    Scraper.start #call all scrapers here trhough start class method
    #Scraper.van_scraper
    #Scraper.bird_scraper
    Event.sort # put after the scrapers to make sure Event class is organized by date, then venue
    puts ""
    puts "      -----------------------------------------"
    puts ""
    puts "      W E L C O M E    T O    J A Z Z    N Y C!"
    puts ""
    puts "      -----------------------------------------"
    puts ""
    puts "                 Today is #{DateTime.now.strftime('%m/%d/%Y')}"
    JazzNyc::CLI.call
  end

  def self.call
    puts " "
    puts "What would you like to do now?".colorize(:red)
    puts " "
    puts "1 = See All Shows, 2 = Find Shows by Date/Day, 3 = Search Shows by Keyword/Performer, 4 = Get Venue Info, 5 = Get Performer Bios, 6 = Exit".colorize(:blue)
    puts " "
    input = gets.chomp

    case input

    when "1"
      Event.complete_list

    when "2"
      puts "Enter the day or date (numerical month/day) you would like to check out:".colorize(:red)
      day = gets.chomp
      Event.day_search(day)

    when "3"
      puts "Enter the performer or keyword (trio, etc.) you would like to search for:".colorize(:red)
      keyword = gets.chomp
      Event.keyword_search(keyword)

    when "4"
      puts "Here's a list of current venues:"
      venues = Event.all.map{|event| event.venue}
      venues.uniq!
      puts ""
      venues.each{|e| puts e.colorize(:blue)} 
      puts ""
      puts "Enter the name of the venue you'd like to know more about".colorize(:red)
      input = gets.chomp
      Event.list_venue(input)

    when "5"
      puts " "
      puts "Here are all the current performers I might have bios for: ".colorize(:red)
      puts " "
      Event.all.each do |event|
        if event.venue == "Smalls" 
          puts event.group
        end
      end
      puts " "
      puts "Who would you like to know more about?".colorize(:red)
      puts "(Enter the first ".colorize(:blue) + "OR ".colorize(:red) + "last name for artist & group info)".colorize(:blue)
      input = gets.downcase.strip
      Event.bio_search(input)  

    when "6"
      Event.clear
      puts ""
      puts "See you at the shows, Jazz Fans!".colorize(:red)
      puts "Thanks!".colorize(:red)
      puts ""
      exit

    else
      puts "I'm sorry, that's not a valid choice".colorize(:red) 
      JazzNyc::CLI.call
    end
  end 
end