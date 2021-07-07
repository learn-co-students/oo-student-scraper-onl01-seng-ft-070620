require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = {}
    students_array = []

    page.css("div.student-card").each do |student|
      students = {
      :name => student.css("a div.card-text-container h4.student-name").text,
      :location => student.css("a div.card-text-container p.student-location").text,
      :profile_url => student.css("a").attribute("href").value
      }
    students_array << students 
    end 
    students_array
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    profile = {}

    page.css("div.social-icon-container a").each do |i|
        link = i.attribute("href").value 
        if link.include?("twitter")
          profile[:twitter] = link
        elsif link.include?("linkedin")
          profile[:linkedin] = link
        elsif link.include?("github")
          profile[:github] = link
        else 
          profile[:blog] = link
        end 
    end 

    profile[:profile_quote] = page.css("div.main-wrapper").css("div.vitals-text-container div.profile-quote").text
    profile[:bio] = page.css("div.main-wrapper").css("div.description-holder p").text
    profile
  end
  
end



