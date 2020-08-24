  
require 'open-uri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_cards = doc.css("div.student-card")
    students_array = []
    student_cards.map do |card|
      hash = {
        :name => card.css("h4.student-name").text,
        :location => card.css("p.student-location").text,
        binding.pry
        :profile_url => card.css("a")[0].attributes["href"].value
      }
      students_array << hash
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    scraped_student = {
        :profile_quote=> doc.css("div.profile-quote").text,
        :bio=> doc.css("div.description-holder p").text,
      }

    if doc.css("div.social-icon-container a")
      doc.css("div.social-icon-container a").each do |a|
        if a.attributes["href"].value.include?("twitter")
          scraped_student[:twitter] = a.attributes["href"].value
        elsif a.attributes["href"].value.include?("linkedin")
          scraped_student[:linkedin] = a.attributes["href"].value
        elsif a.attributes["href"].value.include?("github")
          scraped_student[:github] = a.attributes["href"].value
        else
          scraped_student[:blog] = a.attributes["href"].value
        end
      end
    end
    scraped_student
  end

end

#student_cards = doc.css("div.student-card")
#name = student_cards.css("h4.student-name").text
#location = student_cards.css("p.student-location").text
#profile_url = student_cards[0].css("a")[0].attributes["href"].value


# {
#   :twitter=> doc.css("div.social-icon-container a")[0].attributes["href"].value
#   :linkedin=> doc.css("div.social-icon-container a")[1].attributes["href"].value
#   :github=> doc.css("div.social-icon-container a")[2].attributes["href"].value
#   :blog=> doc.css("div.social-icon-container a")[3].attributes["href"].value
#   :profile_quote=> doc.css("div.profile-quote").text
#   :bio=> doc.css("div.description-holder p").text
# }

