require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    arr = doc.css(".student-card").collect do |card|
      student = {}
      student[:name] = card.css('.student-name').text
      student[:location] = card.css('.student-location').text
      student[:profile_url] = card.css('a').attribute('href').text
      student
    end # do
  end #self.scrape_index_page

  def self.scrape_profile_page(profile_url)
    student = {}
    doc = Nokogiri::HTML(open(profile_url))
    student[:profile_quote] = doc.css('.profile-quote').text
    student[:bio] = doc.css('.bio-content div.description-holder').text.strip
    doc.css('.social-icon-container a').each do |icon|
      netwrk = icon.css('img').attribute('src').text.gsub('../assets/img/', '').split('-')[0]
      netwrk = 'blog' if netwrk == 'rss'
      student[netwrk.to_sym] = icon.attribute('href').text
    end #do
    student

  end # self.scrape_profile_page

end

