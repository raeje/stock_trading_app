# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/users_controller.rb
    class UsersController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request
      before_action :authorize_admin_action, only: %i[update]

      def index
        @users = User.all
        render json: { users: @users }
      end

      # PATCH /api/v1/approve/:id
      def approve
        if @current_user.role == 'admin'
          return render(json: { message: 'You are an ADMIN' })
        end

        render(json: { message: 'You are not an ADMIN' })
      end

      # PATCH /api/v1/update/:id
      def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          render(json: { message: "User #{@user.email} updated." })
        else
          render(json: { errors: @user.errors }, status: :unprocessable_entity)
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation, :role, :name, :is_approved, :id)
      end
    end
  end
end
