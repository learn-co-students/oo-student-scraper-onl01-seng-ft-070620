require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  # url = "https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"
  
  # html = open(url)

  
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url)) #learn_html_to_nodeset
    doc.css("div.student-card").collect do |roster|
      students = {}
        students[:name] = roster.css("div.card-text-container h4").text
        students[:location] = roster.css("div.card-text-container p").text
        students[:profile_url] = roster.css("a").attribute("href").text
      students      
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url)) #learn_html_to_nodeset
    personal_info = {}

    doc.css(".social-icon-container a").each do |social_media|
      social = social_media.css('img').attribute('src').text
      personal_info[:twitter] = doc.css('.social-icon-container a').attribute("href").text if social.include?('twitter')
      personal_info[:linkedin] = doc.css('.social-icon-container a').attribute("href").text if social.include?('linkedin')
      personal_info[:github] = doc.css('.social-icon-container a').attribute("href").text if social.include?('github')
      personal_info[:blog] = doc.css('.social-icon-container a').attribute("href").text if social.include?('rss')
    end

    personal_info[:profile_quote] = doc.css('.profile-quote').text
    personal_info[:bio] = doc.css('.bio-content div.description-holder').text.strip
      # binding.pry
    personal_info
  end

end




