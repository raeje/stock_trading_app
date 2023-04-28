# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/stocks_controller.rb
    class StocksController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request
      before_action :authorize_admin_action, only: %i[create]

      # POST /api/v1/stocks/new
      def create
        @stock = Stock.new(create_params)

        if @stock.save
          render(json: { message: 'Stock created!' }, status: :created)
        else
          render(json: { errors: @stock.errors }, status: :unprocessable_entity)
        end
      end

      # GET /api/v1/stocks/
      def index
        @stock = Stock.all
        render(json: { data: @stock })
      end

      # GET /api/v1/stocks/:id
      def show
        @stock = Stock.find(params[:id])
        render(json: { data: @stock })
      end

      private

      def create_params
        params.permit(:company_name, :last_traded_price, :logo, :quantity, :ticker)
      end
    end
  end
end
