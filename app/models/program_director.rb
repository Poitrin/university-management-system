class ProgramDirector < User
  scope :htw, -> { where(university_id: 'DE') }
  scope :udl, -> { where(university_id: 'FR') }

  belongs_to :study_program

  validates :university_id, presence: true
  validates :study_program_id, presence: true
  validate :associated_person_has_email, if: :person_is_present? # TODO: only way?

  private
  def associated_person_has_email
    person.errors.add(:business_email, :blank) unless person.business_email.present?
  end

  def person_is_present?
    person.present?
  end
end
