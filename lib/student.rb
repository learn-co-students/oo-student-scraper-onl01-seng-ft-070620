class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    @name = student_hash[:name] unless student_hash[:name] == nil
    @location = student_hash[:location] unless student_hash[:location] == nil
    @twitter = student_hash[:twitter] unless student_hash[:twitter] == nil
    @linkedin = student_hash[:linkedin] unless student_hash[:linkedin] == nil
    @github = student_hash[:github] unless student_hash[:github] == nil
    @blog = student_hash[:blog] unless student_hash[:blog] == nil
    @profile_quote = student_hash[:profile_quote] unless student_hash[:profile_quote] == nil
    profile_url = student_hash[:profile_url] unless student_hash[:profile_url] == nil
    self.class.all << self
  end

  def self.create_from_collection(students_array)
    students_array.each do |student|
      # binding.pry
      Student.new(student)
    end
  end

  def add_student_attributes(attributes_hash)
    # self.bio to work
    # binding.pry
    self.twitter = attributes_hash[:twitter]
    self.linkedin = attributes_hash[:linkedin]
    self.github = attributes_hash[:github]
    self.profile_quote = attributes_hash[:profile_quote]
    self.bio = attributes_hash[:bio]
    self.blog = attributes_hash[:blog]

  end

  def self.all
    @@all
  end
end