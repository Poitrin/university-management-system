class Person < ApplicationRecord
  has_secure_password :validations => false # with column "password_digest"
  has_secure_token # with column "token"

  belongs_to :address
  accepts_nested_attributes_for :address
  has_many :diplomas, -> { order(:start_date) }

  before_save :normalize_names

  validates :first_name, presence: true
  validates :surname, presence: true

  # Exclude sensible information
  def as_json(options={})
    new_options = {except: [:password, :token, :matriculationNo, :valid]}
    hash = super(options.merge(new_options))

    hash['firstName'] = hash.delete('firstname')
    hash['gender'] = ['male', 'female'][hash.delete('gender')] if hash['gender'] # gender is either 0 or 1
    hash['isAdministrator'] = (hash.delete('administrator') == 1)

    hash
  end

  def full_name
    "#{first_name} #{surname}"
  end

  def administrator?
    administrator
  end

  private
  def normalize_names
    self.normalized_name = normalize_string(self.first_name) << normalize_string(self.surname)
  end
end
