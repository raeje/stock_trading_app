# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/users_controller.rb
    class UsersController < ApplicationController
      def index
        @users = User.all
        render json: { users: @users }
      end

      # POST signup
      def signup

      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
