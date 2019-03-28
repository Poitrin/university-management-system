class Internship < ApplicationRecord
  paginates_per 39

  MIN_WORKING_DAYS = 1
  MAX_WORKING_DAYS = 7
  MIN_WORKING_HOURS = 10
  MAX_WORKING_HOURS = 50

  belongs_to :student
  belongs_to :study_program, required: true
  belongs_to :enterprise
  belongs_to :program_director, required: false
  belongs_to :university_supervisor, required: false
  belongs_to :enterprise_supervisor, required: false
  belongs_to :address, foreign_key: :internship_address_id, required: false
  belongs_to :authorized_by, foreign_key: 'authorized_by', class_name: 'ProgramDirector', required: false
  belongs_to :validated_by, foreign_key: 'validated_by', class_name: 'ProgramDirector', required: false

  accepts_nested_attributes_for :student
  accepts_nested_attributes_for :enterprise
  accepts_nested_attributes_for :university_supervisor, reject_if: :all_blank
  accepts_nested_attributes_for :enterprise_supervisor, reject_if: :all_blank
  accepts_nested_attributes_for :address, reject_if: :all_blank

  validates :enterprise, presence: true
  validates :student, presence: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :lang_id, presence: true
  validate :end_date_gt_start_date, if: -> { end_date.present? and start_date.present? }
  validate :dates_not_in_another_internship, if: -> { end_date.present? and start_date.present? }
  validates :working_days_per_week,
            allow_blank: true, numericality: true, inclusion: {in: MIN_WORKING_DAYS..MAX_WORKING_DAYS}
  validates :working_hours_per_week,
            allow_blank: true, numericality: true, inclusion: {in: MIN_WORKING_HOURS..MAX_WORKING_HOURS}
  # validates :authorization_reasons, presence: true, if: 'validated == false'
  # validates :validation_reasons, presence: true, if: 'authorized == false'

  attr_accessor :enterprise_and_student_must_exist
  attr_accessor :language_localized
  attr_accessor :start_date_localized
  attr_accessor :end_date_localized
  attr_accessor :payment_per_month_localized
  before_validation :translate_language_localized, if: -> { @language_localized.present? }
  before_validation :translate_payment_per_month, if: -> { @payment_per_month_localized.present? }
  # before_validation :check_if_student_already_exists, if: 'student.present?'
  # before_validation :check_if_enterprise_already_exists, if: 'enterprise.present?'

  scope :study_program_id, -> (study_program_id) { where(study_program_id: study_program_id) }
  scope :lang_id, -> (lang_id) { where(lang_id: lang_id) }
  scope :year, -> (year) do
    date = Date.new(year.to_i, 1, 1)
    where('start_date BETWEEN ? AND ?', date.beginning_of_year, date.end_of_year)
  end

  def self.get_id_for_language_localized(language_localized)
    return nil if language_localized.blank?

    # TODO: Find better solution? Database translation?
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations = I18n.backend.send(:translations)
    [
        translations[:de][:activerecord][:attributes][:offer][:languages],
        translations[:fr][:activerecord][:attributes][:offer][:languages]
    # :en when translated
    ].compact.each do |translation| # only checks non-nil values
      translation.each do |key, value|
        return key.to_s if (value.casecmp(language_localized) == 0) and key.present?
      end
    end

    return nil
  end

  private
  def enterprise_must_exist
    if (enterprise = Enterprise.find_by_normalized_name(self.enterprise.normalized_name))
      self.enterprise = enterprise
    else
      errors.add(:enterprise, :must_exist)
      self.enterprise.errors.add(:name)
    end
  end

  def end_date_gt_start_date
    if end_date <= start_date
      errors.add(:end_date, :greater_than_start_date)
    end
  end

  def dates_not_in_another_internship
    internship_range = (self.start_date..self.end_date)

    self.student.internships.each do |internship|
      next if internship.id == self.id

      if internship_range.cover?(internship.start_date) or internship_range.cover?(internship.end_date)
        errors.add(:start_date, :must_not_lie_in_another_internship)
        errors.add(:end_date, :must_not_lie_in_another_internship)
        break
      end
    end
  end

  def translate_language_localized
    self[:lang_id] = Internship.get_id_for_language_localized(@language_localized)
    errors.add(:language_localized) unless lang_id
  end

  def check_if_student_already_exists
    if (existing_student = Student.find_by_normalized_name(student.normalized_name))
      student.valid?
      existing_student.new_record_to_compare = student

      if student.address
        if existing_student.address
          existing_student.address.new_record_to_compare = student.address
        else
          existing_student.address = student.address
        end
      end

      self.student = existing_student
    end
  end

  def check_if_enterprise_already_exists
    if (existing_enterprise = Enterprise.find_by_normalized_name(enterprise.normalized_name))
      existing_enterprise.new_record_to_compare = enterprise
      self.enterprise = existing_enterprise
    end
  end

  def translate_payment_per_month
    def string_to_float(string)
      return nil if (parts = string.split(/\D/)).empty?
      first_number = parts.shift
      last_number = parts.pop if parts.last =~ /^\d{2}$/
      if parts.all? { |part| part =~ /^\d{3}$/ }
        "#{first_number}#{parts.join('')}.#{last_number}".to_f
      else
        nil
      end
    end

    unless (self[:payment_per_month] = string_to_float(@payment_per_month_localized))
      errors.add(:payment_per_month_localized, :invalid)
    end
  end
end
