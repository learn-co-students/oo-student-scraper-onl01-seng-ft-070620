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
    doc = page.css("div.main-wrapper")

    page.css("div.social-icon-container a").each do |i|
        link = i.attribute("href").value 
        profile[:twitter] = link if link.include?("twitter")
        profile[:linkedin] = link if link.include?("linkedin")
        profile[:github] = link if link.include?("github")
        profile[:blog] = link if i.css("img").attribute("src").text.include?("rss")
    end 

    profile[:profile_quote] = page.css("div.main-wrapper").css("div.vitals-text-container div.profile-quote").text
    profile[:bio] = page.css("div.main-wrapper").css("div.description-holder p").text
    profile
  end
end



