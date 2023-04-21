# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/users_controller.rb
    class UsersController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request
      before_action :authorize_admin_action, only: %i[update create index]

      def index
        @users = User.all
        render json: { data: @users }
      end

      # PATCH /api/v1/users/update/:id
      def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          render(json: { message: "User #{@user.email} updated." })
        else
          render(json: { errors: @user.errors }, status: :unprocessable_entity)
        end
      end

      # POST /api/v1/users/new
      def create
        @user = User.new(user_params)

        if @user.save
          render(json: { message: "User #{@user.email} created!" })
        else
          render(json: { errors: @user.errors }, status: :unprocessable_entity)
        end
      end

      # GET /api/v1/users/portfolio/
      def portfolio
        @portfolio = Portfolio.summary(@current_user.id).joins('FULL JOIN "stocks" ON "stocks"."id" = "stocks_id"').select('portfolios.*,stocks.*')
        # todo: connect portfolio with stock
        # todo: return stock with portfolio.total_quantity
        render(json: { data: @portfolio })
      end

      # GET /api/v1/users/orders/
      def my_orders
        @orders = Order.where(users_id: @current_user.id).joins('FULL JOIN "stocks" ON "stocks"."id" = "stocks_id"').select('orders.*,stocks.company_name')
        render(json: { data: @orders })
      end

      # GET /api/v1/users/me
      def me
        @user = User.find(@current_user.id)
        render(json: { data: @user })
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation, :role, :name, :is_approved, :id)
      end
    end
  end
end
