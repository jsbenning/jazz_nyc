# The CLI Controller
class JazzNyc::CLI

  
  def call
    JazzNyc::Scraper.scrape_smalls  
    puts "--------------------"
    puts ""
    puts "Welcome to Jazz NYC!"
    puts ""
    puts "--------------------"
    JazzNyc::Menu.home 
  end


end

