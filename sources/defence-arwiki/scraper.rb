#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

# Arabic dates
class Arabic < WikipediaDate
  REMAP = {
    'حتى الأن'      => '',
    'يناير'        => 'January',
    'كانون الثاني' => 'January',
    'فبراير'       => 'February',
    'مارس'         => 'March',
    'أبريل'        => 'April',
    'مايو'         => 'May',
    'يونيو'        => 'June',
    'يوليو'        => 'July',
    'أغسطس'        => 'August',
    'سبتمبر'       => 'September',
    'أكتوبر'       => 'October',
    'نوفمبر'       => 'November',
    'ديسمبر'       => 'December',
  }.freeze

  def remap
    super.merge(REMAP)
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

    def date_class
      Arabic
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
