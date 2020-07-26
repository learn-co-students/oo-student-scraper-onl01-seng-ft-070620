require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  url = "https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"
  
  html = open(url)

  doc = Nokogiri::HTML(html) #learn_html_to_nodeset
 
  students = {}

  def self.scrape_index_page(index_url)
    doc.css("div.roster-cards-container").each do |roster|
      data = roster.css("div.student-card").text.to_sym
      binding.pry
      students[data] = {
        :name => roster.css("div.card-text-container h4").text,
        :location => roster.css("div.card-text-container p").text,
        :profile_url => roster.css("div.student-card a").attribute("href").value
      }
      
    end
  end

  def self.scrape_profile_page(profile_url)
    
  end

end




