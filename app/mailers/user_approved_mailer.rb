# frozen_string_literal: true

# app/mailers/user_approved_mailer.rb
class UserApprovedMailer < ApplicationMailer
  default from: 'info.realstrattonoakmont@gmail.com'

  def approved_email(user)
    p '====================================================='
    p '  Sending approved notification email.'
    p '====================================================='
    @user = user
    @url  = 'http://www.gmail.com'
    mail(to: @user.email, subject: 'Congratulations! Your account has been approved.')
  end
end
