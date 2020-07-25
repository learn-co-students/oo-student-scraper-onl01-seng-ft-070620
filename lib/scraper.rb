require 'open-uri'
require 'net/http'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    students = []

    name_array = []
    location_array = []
    url_array = []

    student_names = doc.css(".student-card .student-name")
    student_locations = doc.css(".student-card .student-location")
    student_urls = doc.xpath('//div[@class="student-card"]/a/@href')

    student_hash_array = []
    i = 0

    while i < student_names.length
      student_hash_array << {name: student_names[i].text, location: student_locations[i].text, profile_url: student_urls[i].value}
      i += 1
    end
    student_hash_array
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    student = {}

    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end
end
