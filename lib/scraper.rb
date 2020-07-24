require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    # extract the html data with each student's information
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = doc.css(".student-card")
    
    # parse the data and organize name, location and profile url for each student in an array
    student_arr = []
    
    students.each do |student|
      name = student.css(".card-text-container").css("h4").text
      location = student.css(".card-text-container").css("p").text
      profile_url = student.css("a").first.first.last
      new_student = {:name => name, :location => location, :profile_url => profile_url}
      student_arr.push(new_student)
    end
    
    student_arr # return this array, where each element is a hash with individual student info
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    profile_hash = {}
    profile_hash[:bio] = doc.css(".description-holder").css("p").text
    profile_hash[:profile_quote] = doc.css(".profile-quote").text
    
    arr_of_hashes = doc.css(".social-icon-container").css("a").to_a
    links = arr_of_hashes.map { |hash| hash.values}.flatten
    
    if links.any? { |s| s.include?("twitter.com") } == true
      profile_hash[:twitter] = links.find { |s| s.include?("twitter.com") }
    end
    if links.any? { |s| s.include?("linkedin.com") } == true
      profile_hash[:linkedin] = links.find { |s| s.include?("linkedin.com") }
    end
    if links.any? { |s| s.include?("github.com") } == true
      profile_hash[:github] = links.find { |s| s.include?("github.com") }
    end
    if profile_hash.values.any? { |v| v.include?(links.last)} == false
      profile_hash[:blog] = links.last
    end
    
    profile_hash
  end

end

