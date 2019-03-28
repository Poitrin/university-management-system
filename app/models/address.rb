class Address < ApplicationRecord
  belongs_to :country
  accepts_nested_attributes_for :country

  validates :line1, presence: true
  validates :postal_code, presence: true
  validates :city, presence: true
  validates :country_id, presence: true

  attr_accessor :country_localized
  validate :check_country_localized, if: -> { @country_localized.present? }

  ## TODO: is this allowed (MVC)?
  def lines1_2
    [self.line1, self.line2].compact.join(', ')
  end

  private
  def check_country_localized
    self[:country_id] = Country.get_id_for_name_localized(@country_localized)
    errors.add(:country_localized) unless country_id
  end
end
