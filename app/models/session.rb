class Session
  # LOGIN_ATTEMPTS_LEFT_WARNING = 5

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :person
  attr_accessor :user_name, :password #, :forgot_password

  validates :user_name, presence: true
  validates :password, presence: true #, if: 'forgot_password.nil?' # = if user wants to login and does NOT want to reset their password

  validate :person_exists, if: -> { user_name.present? }
  # TODO: validate :enough_login_attempts_left, if: 'user_name.present? and password.present?'
  validate :password_is_correct, if: -> { password.present? and @person }

  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  # validates_length_of :content, :maximum => 500

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  private
  def person_exists
    @person = Person.find_by_login(user_name.downcase)
    @person = Person.find_by_business_email(user_name) unless @person
    @person = Person.find_by_private_email(user_name) unless @person

    errors.add(:user_name) unless @person
  end

=begin
  def enough_login_attempts_left
    enough = @person.login_attempts_left > 0
    errors.add(:user_name, :too_many_failed_logins) unless enough
    enough
  end
=end

  def password_is_correct
    if @person.authenticate(password)
      # @person.reset_login_attempts # login succeeded = reset login attempt counter, add no error
      @person.regenerate_token
    else
      # @person.increment_login_attempts
      errors.add(:password, :invalid) # if enough_login_attempts_left
    end
  end
end
