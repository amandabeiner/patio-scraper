require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'pry'
require 'csv'

urls = ['http://www.bostonmagazine.com/restaurants/blog/2016/05/08/best-outdoor-dining-boston/', 'http://www.bostonmagazine.com/restaurants/blog/2016/05/08/best-outdoor-dining-boston/2/', 'http://www.bostonmagazine.com/restaurants/blog/2016/05/08/best-outdoor-dining-boston/3/', 'http://www.bostonmagazine.com/restaurants/blog/2016/05/08/best-outdoor-dining-boston/4/', 'http://www.bostonmagazine.com/restaurants/blog/2016/05/08/best-outdoor-dining-boston/5/']

@patios = []
@restaurants = []
@websites = []

urls.each do |url|
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  restaurants = parsed_page.css('p').css('strong')
  websites = parsed_page.css('p').css('em').css('a')

  restaurants.each do |restaurant|
    @restaurants << restaurant.text
  end

  websites.each do |website|
    @websites << website.attributes['href'].value
  end
end

restaurant_hash = [Hash[@restaurants.zip(@websites)]]

CSV.open('patios.csv', 'w') do |csv|
  csv << restaurant_hash
end
