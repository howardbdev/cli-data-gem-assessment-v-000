require 'nokogiri'
require 'open-uri'

# nyc = https://foursquare.com/foursquare/list/trending-this-week-new-york-city
# la =  https://foursquare.com/foursquare/list/trending-this-week-los-angeles
# chicago = https://foursquare.com/foursquare/list/trending-this-week-chicago


class TrendingThisWeek::Scraper
      attr_accessor :name, :location, :rank_change, :type, :rank

    def self.scraper_nyc
      html = open('https://foursquare.com/foursquare/list/trending-this-week-new-york-city')
      trending = Nokogiri::HTML(html)

          trending.css('.hotThisWeekList tbody tr').each do |spot|
                    name = spot.children[2].children[0].text
                    rank =  spot.children[0].text.split('.')[0]
                    rank_change = spot.children[1].children[0].values[0]
                    type = spot.children[2].children[1].text
                    location = spot.children[3].text
                    binding.pry
          end

  end
end
