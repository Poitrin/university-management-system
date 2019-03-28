class Import
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def persisted?
    false
  end

  attr_reader :data
  attr_accessor :spreadsheet

  def initialize(import_params={})
    if (spreadsheet = import_params[:spreadsheet]) # and not @data
      spreadsheet.gsub!("\r", "\n") # TODO: normalize newlines, but when do we need it?
      lines = spreadsheet.scan(/^(?:"[^\t]+"|.)+$/) # ?: means non-capturing group

      @data = lines.map do |line|
        hash = {}

        line.split("\t").map { |item| clean_value(item) }
            .each_with_index { |item, column_number| add(COLUMNS[column_number].split('.'), hash, item) }

        hash
      end
    end
  end

  def create
    Internship.create(@data)
  end

  COLUMNS = ['student_attributes.title_localized',
             'student_attributes.first_name',
             'student_attributes.last_name',
             'student_attributes.birth_name',
             'student_attributes.birth_date_localized',
             'student_attributes.private_email',
             'student_attributes.private_fixed_line',
             'student_attributes.private_cell_phone',
             'student_attributes.business_email',
             'student_attributes.business_fixed_line',
             'student_attributes.business_cell_phone',
             'student_attributes.nationality_localized',
             'student_attributes.second_nationality_localized',
             'student_attributes.address_attributes.line1',
             'student_attributes.address_attributes.line2',
             'student_attributes.address_attributes.postal_code',
             'student_attributes.address_attributes.town',
             'student_attributes.address_attributes.country_localized',
             'student_attributes.user_attributes.user_name',
             'enterprise_attributes.name',
             'enterprise_attributes.profile',
             'enterprise_attributes.website',
             'enterprise_attributes.email',
             'enterprise_attributes.fixed_line',
             'enterprise_attributes.fax',
             'enterprise_attributes.address_attributes.line1',
             'enterprise_attributes.address_attributes.line2',
             'enterprise_attributes.address_attributes.postal_code',
             'enterprise_attributes.address_attributes.town',
             'enterprise_attributes.address_attributes.country_localized',
             'enterprise_attributes.director_attributes.title_localized',
             'enterprise_attributes.director_attributes.first_name',
             'enterprise_attributes.director_attributes.last_name',
             'study_program_localized',
             'degree_localized',
             'start_date_localized',
             'end_date_localized',
             'project_description',
             'project_confidential',
             'working_days_per_week',
             'working_hours_per_week',
             'internship_origin',
             'payment_per_month_localized',
             'language_localized',
             'department',
             'address_attributes.line1',
             'address_attributes.line2',
             'address_attributes.postal_code',
             'address_attributes.town',
             'address_attributes.country_localized',
             'university_supervisor_attributes.title_localized',
             'university_supervisor_attributes.first_name',
             'university_supervisor_attributes.last_name',
             'university_supervisor_attributes.business_email',
             'enterprise_supervisor_attributes.title_localized',
             'enterprise_supervisor_attributes.first_name',
             'enterprise_supervisor_attributes.last_name',
             'enterprise_supervisor_attributes.business_email',
             'enterprise_supervisor_attributes.business_fixed_line',
             'notes']

  private
  def clean_value(value)
    # TODO: check if we really need to replace \r, and "

    return nil if value.blank?
    return value.gsub(/["]/, '') if value =~ /".+"/
    value
  end

  # TODO: copied from shared_world.rb
  def add(keys, hash, value)
    key = keys.shift
    if keys.empty?
      hash[key] = value
    else
      hash[key] ||= {}
      add(keys, hash[key], value)
    end
  end
end