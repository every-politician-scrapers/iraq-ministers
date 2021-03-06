#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ img name _ start end].freeze
    end

    def tds
      noko.css('td,th')
    end

    def raw_end
      super.gsub(/\(.*\)/, '').tidy
    end

    def empty?
      tds[2].text == tds[3].text
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
