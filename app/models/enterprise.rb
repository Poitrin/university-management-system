class Enterprise < ApplicationRecord
  paginates_per 39

  before_create :validate_enterprise

  before_validation :normalize_name

  belongs_to :person, foreign_key: 'created_by', required: false

  validates :name, presence: true
  validates :website, allow_blank: true, format: { with: /\A.*[a-z1-9]+\.[a-z]+.*\z/, message: "is not a valid website link" } # TODO: get a nice regex for URLs!
  # validate :normalized_name_must_be_unique

  delegate :line1, :line2, :postal_code, :town, :country_id, to: :address

  has_many :internships, dependent: :destroy

  belongs_to :address, dependent: :destroy, required: true
  belongs_to :director, dependent: :destroy, required: false # TODO: check if this can really be dependent!

  accepts_nested_attributes_for :director,
                                reject_if: proc { |attributes|
                                  names_are_blank = (attributes[:first_name].blank? and attributes[:surname].blank?)
                                  attributes[:_destroy] = (attributes[:id].present? and names_are_blank) # destroy if...
                                  attributes[:id].blank? and names_are_blank # reject if...
                                },
                                allow_destroy: true
  accepts_nested_attributes_for :address

  # TODO: find a way to destroy contact detail if value is blank
  # accepts_nested_attributes_for :contact_details, reject_if: proc { |attributes| attributes['value'].blank? }

  scope :validated_enterprises, -> { where(is_validated: true) }
  scope :normalized_name, -> (name) do
    term = '%' << ApplicationController.helpers.normalize_string(name) << '%'
    where('normalized_name LIKE ?', term)
  end
  # Note: where(address: {country: ...}) won't work ("stack level too deep")
  scope :country_id, -> (country_id) { joins(:address).where('addresses.country_id = ?', country_id) }

  def normalized_name
    normalize_name
  end

  private
  def validate_enterprise
    self.is_validated = true
  end

  def normalize_name
    self.normalized_name = normalize_string(self.name)
  end

  def normalized_name_must_be_unique
    if new_record? and Enterprise.exists?(normalized_name: self.normalized_name)
      errors.add(:name, :taken)
    end
  end
end
