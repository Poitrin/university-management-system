class StudyProgram < ActiveRecord::Base
  has_many :study_program_details
  accepts_nested_attributes_for :study_program_details

  def name_localized(locale = I18n.locale)
    "#{I18n.t('activerecord.attributes.diploma.degrees.' + degree)}: #{send("name_#{locale}")}"
  end

  def self.get_id_for_study_program_localized(study_program_localized)
    return nil if study_program_localized.blank?

    study_programs = StudyProgram.arel_table
    query = study_programs.project(study_programs[:id]) \
    .where(study_programs[:name_de].matches("%#{study_program_localized}%") \
    .or(study_programs[:name_fr].matches("%#{study_program_localized}%")) \
    .or(study_programs[:name_en].matches("%#{study_program_localized}%")))

    return StudyProgram.find_by_sql(query.to_sql).first.try(:id)
  end
end
