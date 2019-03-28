class User < ActiveRecord::Base
  MAX_LOGIN_ATTEMPTS = 10

  belongs_to :person, required: false
  accepts_nested_attributes_for :person

  has_secure_password
  has_secure_token

  attr_accessor :old_password

  validates :user_name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :password, presence: true, if: :password_presence_must_be_checked?
  validate :old_password_correct

  def self.name_localized(name_symbol)
    I18n.t("user.user_groups.#{name_symbol.to_s}")
  end

  def full_name
    return person.full_name if person
    user_name
  end

  def private_email
    person.private_email if person
  end

  def business_email
    person.business_email if person
  end

  def increment_login_attempts
    # update_column does not modify "updated_at"
    update_column(:login_attempts, login_attempts + 1)
  end

  def reset_login_attempts
    update_column(:login_attempts, 0)
  end

  def login_attempts_left
    MAX_LOGIN_ATTEMPTS - login_attempts
  end

  def self.find_by_email(email)
    person = Person.find_by_private_email(email) || Person.find_by_business_email(email)
    person.user if person
  end

  private
  def old_password_correct
    if old_password.present? and (old_password != password_digest_was) and !authenticate(old_password)
      errors.add(:old_password)
    end
  end

  def password_presence_must_be_checked?
    (user_name.present? and new_record?) or old_password.present?
  end

end
