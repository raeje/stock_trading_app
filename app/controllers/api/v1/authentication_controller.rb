# frozen_string_literal: true

# TODO
# 1. Lock user for a certain period
#    - 5 incorrect password attempts

module Api
  module V1
    # app/controllers/api/v1/authorization_controller.rb
    class AuthenticationController < ApplicationController
      # Protect from cross site request forgery
      protect_from_forgery with: :null_session
      before_action :authorize_request, except: %i[signup login]

      # POST /signup
      # Register new user
      def signup
        # Create new User object
        @user = User.new(user_params)

        if params[:password] == params[:password_confirmation]
          if @user.save
            # Send an email after creation of new user
            UserSignupMailer.welcome_email(@user).deliver_now
            # Create new User record with encrypted password
            @user = User.encrypt_password(user_params)
            render(json: { message: 'Account created.' }, status: :created)
          else
            render(json: { errors: @user.errors }, status: :unprocessable_entity)
          end
        else
          render(json: { errors: { password: ['do not match.'] } }, status: :unprocessable_entity)
        end
      end

      # PUT /login
      # Enable user log in, returns token
      def login
        @user = User.find_by_email(params[:email])

        # Check if email or password is empty
        if params[:email].to_s.empty? || params[:password].to_s.empty?
          return(render(json: { errors: 'Email and password can\'t be blank' }, status: :unauthorized))
        end

        # Check if user is exists
        return render(json: { errors: 'User not found.' }, status: :not_found) unless @user

        # Check if user is approved
        return render(json: { errors: 'Pending approval.' }, status: :not_found) if @user.is_approved == false

        # Check if password is correct using BCrypt
        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          render(json: { token:,
                         exp: time.strftime('%m-%d-%Y %H:%M'),
                         email: @user.email },
                 status: :ok)
        else
          render(json: { errors: 'Incorrect password. Please try again.' }, status: :not_found)
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation, :role, :is_approved)
      end
    end
  end
end
