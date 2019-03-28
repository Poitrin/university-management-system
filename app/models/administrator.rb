class Administrator < User
  scope :htw, -> { where(university_id: 'DE') }
  scope :udl, -> { where(university_id: 'FR') }

  validates :university_id, presence: true
  validates :person, presence: true, if: :person_id_is_blank?
  validates :person_id, presence: true, if: :person_is_blank?

  def locale
    university_id.downcase.to_sym
  end

  private
  def person_id_is_blank?
    person_id.blank?
  end

  def person_is_blank?
    person.blank?
  end
end
