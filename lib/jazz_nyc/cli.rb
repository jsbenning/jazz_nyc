# The CLI Controller

class JazzNyc::CLI

  def call
    intro 
    menu
    goodbye 
  end

  def intro
    puts "--------------------" 
    puts ""
    puts "Welcome to Jazz NYC!"
    puts ""

    puts "--------------------"  
    end

  def menu
    puts "Would you like to"
    puts ""
    puts "a) Check out upcoming events by venue"
    puts "b) Check out upcoming events by date"
    puts "c) Check out upcoming events by artist" 
    puts "or enter exit to quit"
    puts ""
    input = nil
    while input != "exit"
      input = gets.strip.downcase
      case input
      when "a"
        puts "Here are the clubs we have for you to choose from:"
        puts ""
        puts <<-DOC
          1 Village Vanguard
          2 Dizzy's Club Coca Cola
          3 Blue Note
          4 Iridium
          5 Jazz Standard
          6 Small's
          DOC
        puts ""
      when "b"
        puts "Here are some upcoming shows by date: "
        puts ""
      when "c"
        puts "Here's a list of performers: "
        puts ""
      end
    end 
  end

  def goodbye
    puts ""
    puts "Stay cool, jazzlover!"
  end

end

