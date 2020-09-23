require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_url = student.attr('href')
        student_name = student.css(".student-name").text
        student_location =student.css(".student-location").text
        students << {name: student_name, location: student_location, profile_url: student_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile = Nokogiri::HTML(open(profile_url))
    student_links = profile.css(".social-icon-container").children.css("a").map { |l| l.attr("href")}
    student_links.each do |link|
       if link.include?("twitter")
        student[:twitter] = link
       elsif link.include?("linkedin")
        student[:linkedin] = link
       elsif link.include?("github")
        student[:github] = link
       else
        student[:blog] = link
       end
    end
    student[:profile_quote] = profile.css(".profile-quote").text
    student[:bio] = profile.css(".description-holder p").text

    student
  end

end

