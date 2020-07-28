require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    flatiron = Nokogiri::HTML(html)
 
    students = []
    flatiron.css("div.student-card").collect do |student|
      student_hash = {
        :name => student.css("a div.card-text-container h4.student-name").text,
        :location => student.css("a div.card-text-container p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    profile = Nokogiri::HTML(html)

    profile_hash = {}
    social_links = profile.css("div.social-icon-container a")

      social_links.each do |social_link|
        if social_link.attribute("href").value.include? "twitter"
          profile_hash[:twitter] = social_link.attribute("href").value
        elsif social_link.attribute("href").value.include? "linkedin"
          profile_hash[:linkedin] = social_link.attribute("href").value
        elsif social_link.attribute("href").value.include? "github"
          profile_hash[:github] = social_link.attribute("href").value
        else
          profile_hash[:blog] = social_link.attribute("href").value
        end
      end
      profile_hash[:profile_quote] = profile.css("div.profile-quote").text
      profile_hash[:bio] = profile.css("div.description-holder p").text
    profile_hash
  end
end

