require 'nokogiri'
require 'open-uri'


class TrendingThisWeek::Scraper
      attr_accessor :name, :location, :rank_change, :type, :rank, :spot_url, :address, :city, :phone_number,
      :other_info, :all_top_places, :rating, :list_name, :list_url

    def self.scraper(index_page)
      html = open(index_page)
      trending = Nokogiri::HTML(html)
      spots_array = []
          trending.css('.hotThisWeekList tbody tr').each do |spot|
                    name = spot.children[2].children[0].text
                    rank =  spot.children[0].text.split('.')[0]
                    rank_change = spot.children[1].children[0].values[0]
                    rank_change_value = spot.children[1].children[0].text
                    type = spot.children[2].children[1].text
                    location = spot.children[3].text
                    spot_url = "https://foursquare.com#{spot.children[2].children[0].attribute('href').value}"
                    if rank_change.include? 'Positive'
                        rank_change = "+ #{rank_change_value}"
                      elsif rank_change.include? 'Negative'
                        rank_change = "- #{rank_change_value}"
                      else
                        rank_change = '0'
                      end

          spot = {:name => name, :rank => rank, :rank_change => rank_change, :type => type, :location => location, :spot_url => spot_url}
          spots_array<<spot
        end
            spots_array
  end

  def self.scraper_spot_page(spot_url)
    html = open(spot_url)
    spot_page = Nokogiri::HTML(html)

    address_array = spot_page.css('.adr').text.split(/(?<!\s|[A-Z])(?=[A-Z])|,/)
    address = address_array[0]
    city = address_array[1]
    phone_number = spot_page.css('.tel').text

        i = 0
        other_info = []
        while i < spot_page.css('.venueRowKey').length
          key = spot_page.css('.venueRowKey')
          value = spot_page.css('.venueRowValue')
          other_info << "#{key[i].text} - #{value[i].text}"
          i+=1
        end
        more_info = [address, city, phone_number, other_info]
  end

  def self.scrape_top_places
  html = open('https://foursquare.com/top-places/new-york-city/best-places-burgers')
  explore = Nokogiri::HTML(html)
  all_top_places = []
    title =  explore.css('h1').text
      explore.css('.venueInfo').each do |top|
          rank_and_name = top.children[0].children[0].text.split('.')
          name = rank_and_name[0]
          rank = rank_and_name[1]
          rating = top.children[0].children[1].text
          address = top.children[0].children[2].text
          type_location = top.children[0].children[3].text.split('·')
          type = type_location[0].strip
          location = type_location[1].strip
          spot_url = "https://foursquare.com#{explore.css('.venueInfo a').attribute('href').value}"
          all_top_places << top_place = {:name => name,:rank => rank, :rating =>rating, :address => address, :type => type , :location => location, :spot_url => spot_url}

        end
      all_top_places
end

def self.list_page
  html = open('https://foursquare.com/top-places/new-york-city/')
  list = Nokogiri::HTML(html)
  list_array = []
        list.each do |list_names|
        list_name = list.css('.listName').text
        list_url = list.css('.listCard a').attribute('href').value
        new_list =  { :list_name => list_name, :list_url=> list_url}
        list_array << new_list
        binding.pry
      end
      # binding.pry
end


end
