# Preview all emails at http://localhost:3000/rails/mailers/user_signup_mailer
class UserSignupMailerPreview < ActionMailer::Preview
  def new_user_signup_email
    # Set up a temporary order for the preview
    user = User.new(name: "Joe Smith", email: "joe@gmail.com")

    UserSignupMailer.with(user: user).new_user_signup_email
  end
end
