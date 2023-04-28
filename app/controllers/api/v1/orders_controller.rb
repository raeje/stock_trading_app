# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/orders_controller.rb
    class OrdersController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request
      before_action :authorize_trader_action, only: %i[create]
      before_action :authorize_admin_action, only: %i[index]

      # GET /api/v1/orders
      def index
        @orders = Order.all.joins('LEFT JOIN "stocks" ON "stocks"."id" = "stocks_id"').select('orders.*,stocks.company_name')
        render(json: { data: @orders })
      end

      # POST /api/v1/orders/new
      def create
        @order = Order.new(create_params)

        if @order.save
          render(json: { order: @order, message: 'Order created!' }, status: :created)
        else
          render(json: { errors: @order.errors }, status: :unprocessable_entity)
        end
      end

      # PATCH /api/v1/orders/update/:id
=begin
      def update
        @order = Order.find(params[:id])

        if @order.update(order_params)
          render(json: { message: 'Order updated!' }, status: :ok)
        else
          render(json: { errors: @order.errors }, status: :unprocessable_entity)
        end
      end
=end

      private

      # def order_params
      #   params.permit(:category, :price, :status, :expiry_date)
      # end

      def create_params
        params.permit(:category, :price, :quantity, :status, :stocks_id, :users_id)
              .with_defaults(quantity: 1, status: 'placed', users_id: @current_user.id)
      end
    end
  end
end
