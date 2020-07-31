require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    data = Nokogiri::HTML(html)
    student_cards = data.css(".student-card a")
    student_cards.collect do |i|
      {:name => i.css(".student-name").text ,
        :location => i.css(".student-location").text,
        :profile_url => i.attr('href')
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    data = Nokogiri::HTML(html)
    hash = {}
    social = data.css(".vitals-container .social-icon-container a")
    social.each do |i|
      if i.attr('href').include?("twitter")
        hash[:twitter] = i.attr('href')
      elsif i.attr('href').include?("linkedin")
        hash[:linkedin] = i.attr('href')
      elsif i.attr('href').include?("github")
        hash[:github] = i.attr('href')
      elsif i.attr('href').end_with?("com/")
        hash[:blog] = i.attr('href')
      end
    end
    hash[:profile_quote] = data.css(".vitals-container .vitals-text-container .profile-quote").text
    hash[:bio] = data.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text
    hash
  end

end

