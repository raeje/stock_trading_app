# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/orders_controller.rb
    class OrdersController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request
      before_action :authorize_trader_action, only: %i[create]

      def create
        # @order = Order.new(params[:category], params[:price], status: 'placed')
        @order = Order.new(create_params)

        if @order.save
          render(json: { message: 'Order created!' })
        else
          render(json: { errors: @order.errors }, status: :unprocessable_entity)
        end
      end

      private

      def order_params
        params.permit(:category, :price, :expiry_date, :user_id, :stock_id)
      end

      def create_params
        p @current_user
        params.permit(:category, :price, :quantity, :status, :stocks_id, :users_id)
              .with_defaults(quantity: 1, status: 'placed', users_id: @current_user.id)
      end
    end
  end
end
