class Diploma < ActiveRecord::Base
  BACHELOR = 'B'
  MASTER = 'M'

  belongs_to :student, required: false
  belongs_to :study_program

  attr_accessor :promotion
  attr_accessor :degree_localized
  attr_accessor :study_program_localized
  attr_accessor :registration_country_localized
  validate :check_studies_start # includes promotion
  before_validation :translate_degree_localized, if: -> { @degree_localized.present? }
  before_validation :translate_study_program_localized, if: -> { @study_program_localized.present? }
  before_validation :translate_registration_country_localized, if: -> { @registration_country_localized.present? }

  validates :study_program_id, presence: true
  # validates :studies_start, presence: true

  def self.get_id_for_degree_localized(degree_localized)
    return nil if degree_localized.blank?

    # TODO: Find better solution? Database translation?
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations = I18n.backend.send(:translations)
    [
        translations[:de][:activerecord][:attributes][:diploma][:degrees],
        translations[:fr][:activerecord][:attributes][:diploma][:degrees]
    # :en when translated
    ].compact.each do |translation| # only checks non-nil values
      translation.each do |key, value|
        return key.to_s if (value.casecmp(degree_localized) == 0) and key.present?
      end
    end

    return nil
  end

  def study_period
    study_period = "#{studies_start.year.to_s} &mdash; "
    (studies_end.present? ? "#{study_period} #{studies_end.year.to_s}" : "#{study_period} ?")
  end

  private
  def check_studies_start
    if @promotion.blank? and studies_start.blank?
      # errors.add(:studies_start, :blank)
      errors.add(:promotion, :blank)
      return
    end

    if @promotion.present? and studies_start.blank?
      begin
        self[:studies_start] = Date.new(@promotion.to_i, 9, 1)
      rescue
        errors.add(:promotion)
      end
    end
  end

  def translate_study_program_localized
    self[:study_program_id] = StudyProgram.get_id_for_study_program_localized(@study_program_localized)
    errors.add(:study_program_localized) unless study_program_id
  end
end
