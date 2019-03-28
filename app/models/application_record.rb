class ApplicationRecord < ActiveRecord::Base
  ATTRIBUTES_TO_IGNORE = ['name', 'first_name', 'last_name', 'created_at', 'updated_at']

  self.abstract_class = true

  before_validation :translate_dates

  attr_accessor :new_record_to_compare
  validate :new_record_has_no_differences, if: -> { new_record_to_compare.present? }

  def new_record_has_no_differences
    hashes = [self, new_record_to_compare].map do |record|
      # remove nil values
      record.serializable_hash.compact
    end

    differences = HashDiff.diff(*hashes)

    differences.each do |difference|
      # ignore removals
      next if difference[0] == '-'

      # ignore the columns
      next if ATTRIBUTES_TO_IGNORE.include?(difference[1])

      errors.add(difference[1], :is_different)
    end
  end

  def normalize_string(string)
    ApplicationController.helpers.normalize_string(string)
  end

  def string_to_date(string)
    # German or French formats with 2 digit years
    if string =~ /^\d{1,2}\W\d{1,2}\W\d{2}$/
      string.gsub!(/\W/, ' ')
      return Date.strptime(string, '%d %m %y')
    end

    Date.parse(string)
  rescue ArgumentError
    nil
  end

  def translate_date(column_name)
    return if (string = self.try("#{column_name}_localized")).blank?

    if (translated_date = string_to_date(string))
      write_attribute(column_name.to_sym, translated_date)
    else
      errors.add(column_name.to_sym, :invalid)
    end
  end

  def translate_dates
    self.attribute_names
        .select { |a| a =~ /_date$/ }
        .each { |column| translate_date(column) }
  end
end
