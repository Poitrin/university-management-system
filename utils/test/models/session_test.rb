require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  require 'SecureRandom'

  USER_NAME = 'oblivion'
  USER_PASSWORD = 'iforgot10'
  USER_EMAIL = 'joh.for@gmx.de'

  test 'user account gets locked' do
    forgetful_user = create_forgetful_user
    assert forgetful_user.save
    assert_equal 0, forgetful_user.login_attempts

    (1..User::MAX_LOGIN_ATTEMPTS).each do |run|
      session = Session.new(user_name: (run % 2 > 0 ? USER_NAME : USER_EMAIL), # log in with username or email
                            password: SecureRandom.hex)
      assert_equal false, session.valid?
      assert_equal forgetful_user.reload.id, session.user.id
      assert_equal run, forgetful_user.reload.login_attempts
      assert_equal User::MAX_LOGIN_ATTEMPTS - forgetful_user.login_attempts, forgetful_user.login_attempts_left
    end

    # User can't log in again, even though their credentials are correct
    (1..2).each do |run|
      session = Session.new(user_name: (run % 2 > 0 ? USER_NAME : USER_EMAIL),
                            password: USER_PASSWORD)
      assert_equal false, session.valid?
      assert_equal forgetful_user.reload.id, session.user.id
      assert_equal User::MAX_LOGIN_ATTEMPTS, forgetful_user.reload.login_attempts
    end

    forgetful_user.destroy
  end

  test 'user finds password again' do
    forgetful_user = create_forgetful_user
    assert forgetful_user.save
    assert_equal 0, forgetful_user.reload.login_attempts

    (1..(User::MAX_LOGIN_ATTEMPTS-1)).each do |run|
      session = Session.new(user_name: (run % 2 > 0 ? USER_NAME : USER_EMAIL), # log in with username or email
                            password: SecureRandom.hex)
      assert_equal false, session.valid?
    end

    # Oh, oh…
    assert_equal 1, forgetful_user.reload.login_attempts_left

    # Last try - this time, it works!
    session = Session.new(user_name: USER_NAME, password: USER_PASSWORD)
    assert_equal true, session.valid?
    assert_equal 0, forgetful_user.reload.login_attempts
    assert_equal User::MAX_LOGIN_ATTEMPTS, forgetful_user.reload.login_attempts_left

    forgetful_user.destroy
  end

  private
  def create_forgetful_user
    Administrator.new(user_name: USER_NAME,
                      password: USER_PASSWORD,
                      password_confirmation: USER_PASSWORD,
                      university_id: 'DE',
                      person_attributes: {first_name: 'Johnny',
                                          last_name: 'Forgotten',
                                          business_email: USER_EMAIL})
  end
end
