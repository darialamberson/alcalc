require 'nokogiri'
require 'open-uri'
require 'mechanize'


namespace :db do

  task :wine_scraper => :environment do
    Drank.destroy_all
    traverse
  end

  def traverse
    page = Mechanize.new.get('http://www.wine.com/v6/wineshop/')

    begin
      # follow each wine link and scrape
      linkz = page.links_with(:class => 'listProductName')
      # link_spans = page.search "//span[@id='ctl00_BodyContent_ctrProducts_ctrPagingTop_dlPageLinks']/span"
      linkz.each do |link|
        get_and_insert_info(link.click)
      end

      # go to the next page
      page = page.link_with(:text => 'Next').click
    end while page.link_with(:text => 'Next')
  end

  def get_and_insert_info(page)
    title = page.search("h1#ctl00_BodyContent_productTitle").inner_text.gsub (/ ?\d\d\d\d$/), ''
    percentage = page.search("//span[@id='ctl00_BodyContent_wctAbstract_lblAlcoholPct']")
    unless percentage.empty?
      alcohol_by_volume = (percentage.inner_text.gsub '%', '').to_f
      pp Drank.create(:drink_name => title, :alcohol_content => alcohol_by_volume, :drink_type => 'wine')
    end
  end

end