require 'open-uri'
require 'pry'

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



