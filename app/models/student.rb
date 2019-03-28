class Student < Person
  paginates_per 42

  has_many :internships, dependent: :destroy
  belongs_to :address #, required: true

  scope :study_program_id, -> (study_program_id) do
    joins(:diplomas) \
    .where(diplomas: {study_program_id: study_program_id}).distinct
  end
  scope :degree, -> (degree) do
    joins(:diplomas) \
    .where(diplomas: {degree: degree}).distinct
  end
  scope :promotion, -> (promotion) do
    joins(:diplomas) \
    .where(:diplomas => {:studies_start => Date.new(promotion.to_i, 1, 1)..Date.new(promotion.to_i, 12, 31)})
  end
  scope :full_name, -> (term) do
    term = '%' << term.split(' ')
                      .map { |unnormalized_name| ApplicationController.helpers.normalize_string(unnormalized_name) }.join('%') << '%'
    where('normalized_name LIKE ?', term)
  end

  before_destroy :validate_no_internships

  has_many :diplomas
  accepts_nested_attributes_for :diplomas,
                                reject_if: proc { |attributes| attributes['degree'].blank? and \
                                attributes['degree_localized'].blank? and \
                                attributes['study_program_id'].blank? and \
                                attributes['study_program_localized'].blank? and \
                                attributes['studies_start'].blank? }
  
  attr_accessor :nationality_localized,
                :second_nationality_localized
  validate :check_nationality_localized, if: -> { @nationality_localized.present? }
  validate :check_second_nationality_localized, if: -> { @second_nationality_localized.present? }

  def nationality_localized(locale=I18n.locale)
    Country.find(nationality)["name_#{locale.to_s.downcase}"]
  rescue
    @nationality_localized
  end

  def second_nationality_localized(locale=I18n.locale)
    Country.find(second_nationality)["name_#{locale.to_s.downcase}"]
  rescue
    @nationality_localized
  end

  # returns the last diploma (first row of ORDER BY studies_start DESC)
  def last_diploma
    diplomas.order(studies_start: :desc).first if diplomas
  end

  private
  def validate_no_internships
    if internships.count > 0
      false
    end
  end

  # TODO: DRY principle?!
  def check_nationality_localized
    self[:nationality] = Country.get_id_for_name_localized(@nationality_localized)
    errors.add(:nationality_localized) unless nationality
  end

  def check_second_nationality_localized
    self[:second_nationality] = Country.get_id_for_name_localized(@second_nationality_localized)
    errors.add(:second_nationality_localized) unless second_nationality
  end
end