require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInterface
  # page thats acting as the file path for the scraper
  BASE_PATH = "https://learn-co-curriculum.github.io/student-scraper-test-page/"

  
  def run
    make_students
    add_attributes_to_students
    display_students
  end

  #makes an array of students using the .scrape_index_page class method on the Scraper class calling BASE_PATH + 'index.html' as the argument
  #instantiates inividual instances of the student class using .create_from_collection with the array of students created from BASE_PATH + 'index.html' as the argument
  def make_students
    students_array = Scraper.scrape_index_page(BASE_PATH + 'index.html')
    Student.create_from_collection(students_array)
  end

  # iterates through all instances of Student class
  # creates a hash of attributes using .scrape_profile_page class method on Scraper -- argument is BASE_PATH + .profile_url of each instance of Student\
  # adds attributes to instance of Student from attributes hash using .add_student_attributes
  def add_attributes_to_students
    Student.all.each do |student|
      attributes = Scraper.scrape_profile_page(BASE_PATH + student.profile_url)
      student.add_student_attributes(attributes)
    end
  end

  # iterates through Students and puts their info
  def display_students
    Student.all.each do |student|
      puts "#{student.name.upcase}".colorize(:blue)
      puts "  location:".colorize(:light_blue) + " #{student.location}"
      puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
      puts "  bio:".colorize(:light_blue) + " #{student.bio}"
      puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
      puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
      puts "  github:".colorize(:light_blue) + " #{student.github}"
      puts "  blog:".colorize(:light_blue) + " #{student.blog}"
      puts "----------------------".colorize(:green)
    end
  end

end
