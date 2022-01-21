#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

# Arabic dates
class Arabic < WikipediaDate
  REMAP = {
    'حتى الأن'      => '',
    'كانون الثاني' => 'January',
    'FEBRUARY'     => 'February',
    'مارس'         => 'March',
    'أبريل'        => 'April',
    'مايو'         => 'May',
    'يونيو'        => 'June',
    'يوليو'        => 'July',
    'أغسطس'        => 'August',
    'سبتمبر'       => 'September',
    'أكتوبر'       => 'October',
    'NOVEMBER'     => 'November',
    'ديسمبر'       => 'December',
  }.freeze

  def remap
    super.merge(REMAP)
  end

  def date_str
    super.gsub('1er', '1')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'صورة'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name img start end].freeze
    end

    def tds
      noko.css('td,th')
    end

    def empty?
      false
    end

    def date_class
      Arabic
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
