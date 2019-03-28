class UserMailer < ApplicationMailer

  def password_reset_mail(user)
    @user = user
    # @url  = 'http://example.com/login'
    mail(to: @user.private_email || @user.business_email)
  end

end
