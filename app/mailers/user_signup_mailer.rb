# frozen_string_literal: true

# app/mailers/user_signup_mailer.rb
class UserSignupMailer < ApplicationMailer
  default from: 'info.realstrattonoakmont@gmail.com'

  def welcome_email(user)
    p '====================================================='
    p '  New registration detected. Sending welcome email.'
    p '====================================================='
    @user = user
    @url  = 'http://www.gmail.com'
    mail(to: @user.email, subject: 'Welcome to Stratton Oakmont!')
  end
end
