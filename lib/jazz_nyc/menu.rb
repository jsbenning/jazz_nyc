require 'pry'
require 'colorize'

class JazzNyc::Menu
  def self.home
    puts " "
    puts "What would you like to do now?".colorize(:red)
    puts " "
    puts "1 = See All Shows, 2 = Find Shows by Date/Day, 3 = Search Shows by Keyword/Performer, 4 = Get Venue Info, 5 = Exit".colorize(:blue)
    puts " "
    input = gets.chomp

    case input
    when "1"
      Event.complete_list
    when "2"
      puts "Enter the day or date (numerical month / day) you would like to check out:".colorize(:red)
      day = gets.chomp
      if day.include?("/")
        Event.date_search(day)
      else
        Event.day_search(day)
      end
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
      Event.clear
      puts ""
      puts "See you at the shows, Jazz Fans!".colorize(:red)
      puts "Thanks!".colorize(:red)
      puts ""
      exit
    else
      puts "I'm sorry, that's not a valid choice".colorize(:red) 
      Menu.home 
    end
  end
  
end