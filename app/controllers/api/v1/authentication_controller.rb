# frozen_string_literal: true

module Api
  module V1
    # app/controllers/api/v1/authorization_controller.rb
    class AuthenticationController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request, except: %i[signup login]

      # POST /signup
      # Register new user
      def signup
        # Create new User object
        @user = User.new({ email: params[:email], password: params[:password] })
        if params[:password] == params[:password_confirmation]
          if @user.save
            # Create new User record with encrypted password
            @user = User.encrypt_password(user_params)
            render(json: { message: ['Account created.'] }, status: :created)
          else
            render(json: { errors: @user.errors }, status: :unprocessable_entity)
          end
        else
          render(json: { errors: { password: ['Passwords do not match.'] } }, status: :unprocessable_entity)
        end
      end

      # PUT /login
      # Enable user log in, returns token
      def login
        # Check if email or password is empty
        if params[:email].to_s.empty? || params[:password].to_s.empty?
          return(render(json: { errors: ['Email and password can\'t be blank']}, status: :unauthorized))
        end

        # Check if user is found on the db
        begin
          @user = User.find_by(email: params[:email])
        rescue ActiveRecord::RecordNotFound => e
          return render(json: { errors: e.message }, status: :unauthorized)
        end

        # Check if password is correct using BCrypt
        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          render(json: { token:,
                         exp: time.strftime('%m-%d-%Y %H:%M'),
                         email: @user.email },
                 status: :ok)
        else
          render(json: { errors: ['Incorrect password. Please try again.'], status: :unauthorized })
        end
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
