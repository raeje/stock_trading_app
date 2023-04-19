# frozen_string_literal: true

# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'info.realstrattonoakmont@google.com'
  layout 'mailer'
end
