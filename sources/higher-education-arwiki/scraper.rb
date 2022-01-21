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
    'شباط'         => 'February',
    'فبراير'       => 'February',
    'آذار'         => 'March',
    'مارس'         => 'March',
    'نيسان'        => 'April',
    'أبريل'        => 'April',
    'مايو'         => 'May',
    'أيار'         => 'May',
    'يونيو'        => 'June',
    'حزيران'       => 'June',
    'يوليو'        => 'July',
    'تموز'         => 'July',
    'أغسطس'        => 'August',
    'آب'           => 'August',
    'أيلول'        => 'September',
    'سبتمبر'       => 'September',
    'أكتوبر'       => 'October',
    'تشرين الأول'   => 'October',
    'نوفمبر'       => 'November',
    'تشرين الثاني' => 'November',
    'كانون الأول'   => 'December',
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
