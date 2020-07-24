require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |card|
      profile_ext = card.css('a').attribute('href').text
      pself.scrape_profile_page(index_url + profile_ext)
      # binding.pry
    end # do
  end

  def self.scrape_profile_page(profile_url)
    
  end

end

