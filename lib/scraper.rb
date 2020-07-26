require 'open-uri'
require 'pry'

require 'json'
require 'Nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    #open-uri pulls down the raw HTML of the webpage
    html = open(index_url)

    #Nokogiri parses the HTML and converts it into a structure of nested nodes (a hash-like object)
    doc = Nokogiri::HTML(html)

    # student_array is a collection of hashes -- each hash contains name, location and profile_url keys and their associated value for each student
    student_array = doc.css(".student-card").collect do |student|
      {
        name: student.css("h4").text,
        location: student.css("p").text,
        profile_url: student.css("a").first["href"]
      }
    end

    #return student_array
    student_array
  end



  def self.scrape_profile_page(profile_url)
    #open-uri pulls down the raw HTML of the webpage
    html = open(profile_url)

    #Nokogiri parses the HTML and converts it into a structure of nested nodes (a hash-like object)
    doc = Nokogiri::HTML(html)
    
    # links is an object made up of the different 'a' links that are children of .social-icon-container
    links = doc.css(".social-icon-container a")

    # creating empty student_hash then iterating through links to grab the social media links that are available on the page
    student_hash = {}
        links.each do |link|
          if link["href"].include?("twitter")
            student_hash[:twitter] = link["href"]
          elsif link["href"].include?("linkedin")
            student_hash[:linkedin] = link["href"]
          elsif link["href"].include?("github")
            student_hash[:github] = link["href"]
          elsif !link["href"].include?("twitter" || "github" || "linkedin")
            student_hash[:blog] = link["href"]
          end
        end

        #adding profile_quote and bio to the student_hash
        student_hash[:profile_quote] = doc.css(".profile-quote").text
        student_hash[:bio] = doc.css("p").text
    
    # returning student hash
    student_hash
  end

end

