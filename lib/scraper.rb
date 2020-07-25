require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    scraped_students = []
    students = {}
    index_page = Nokogiri::HTML(open(index_url))
    index_page.css("div.student-card").each do |student|
    students = {  :name => student.css("div.card-text-container h4.student-name").text,
                  :location => student.css("div.card-text-container p.student-location").text,
                  :profile_url => student.css("a").attribute("href").value }
    scraped_students << students          
    end 
   scraped_students
  
  end

  def self.scrape_profile_page(profile_url)
    students = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    # links = profile_page.css("div.social-icon-container a").attribute("href").value
    profile_page.css("div.social-icon-container a").each do |link|
      links = link.attribute("href").value
     if links.include?("twitter") 
      students[:twitter] = links
     elsif links.include?("linkedin") 
      students[:linkedin] = links
     elsif links.include?("github") 
      students[:github] = links
     else
      students[:blog] = links
    end 
  end 
      students[:profile_quote] = profile_page.css("div.vitals-text-container div.profile-quote").text
      students[:bio] =  profile_page.css("div.description-holder p").text
  students 
  end

end