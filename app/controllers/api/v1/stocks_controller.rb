# frozen_string_literal: true

module Api
  module V1
    # app/controller/api/v1/orders_controller.rb
    class StocksController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authorize_request
      before_action :authorize_trader_action, only: %i[create]

      # GET /api/v1/stocks/:id
      def show
        @stock = Stock.find(params[:id])
        render(json: { stock: @stock })
      end
    end
  end
end
