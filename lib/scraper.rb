require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    students = []
    
    doc.css("div.student-card").each do |student| # for each student-card, do below
      name = student.css(".student-name").text # in each student-card, select their name
      location = student.css(".student-location").text # in each student-card, select their location
      profile_url = student.css("a").attribute("href").value # placeholder -- find their profile link

      each_student = { #for each student-card, create hash with the variables retrieved
        name: name,
        location: location,
        profile_url: profile_url
      }
      students << each_student #shovel each student hash into an array
    end
    students #return that array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    student_data = {}
    
    socials = doc.css(".social-icon-container a")#.attribute("href").value
    socials.each do |link|
      # binding.pry
      if link.attribute("href").value.include?("twitter")
        student_data[:twitter] = link.attribute("href").value
      elsif link.attribute("href").value.include?("linkedin")
        student_data[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include?("github")
        student_data[:github] = link.attribute("href").value
      elsif link.attribute("href").value.include?(".com")
        student_data[:blog] = link.attribute("href").value
      end
      student_data[:profile_quote] = doc.css(".profile-quote").text
      student_data[:bio] = doc.css(".description-holder p").text
    end
    student_data
  end
end

