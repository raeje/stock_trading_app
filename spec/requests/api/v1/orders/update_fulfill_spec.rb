# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  describe 'update order from placed to fulfilled' do
    context 'valid parameters' do
      let(:user_trader) { create(:user, :trader) }
      let(:user_admin) { create(:user, :admin) }
      let(:stock_valid) { create(:stock, :valid) }
      let(:order) { build(:order) }

      before do
        login_as(user_admin)
        approve_user(user_trader, { Authorization: json['token'] })
        login_as(user_trader)
      end

      it 'should complete buy order then set order status to fulfilled' do
        place_buy_order(order, stock_valid, user_trader, { Authorization: json['token'] })
        fulfilled_order = fulfill_order_buy!
        expect(fulfilled_order.status).to eq('fulfilled')
      end

      it 'should complete sell order then set order status to fulfilled' do
        headers = { Authorization: json['token'] }
        place_buy_order(order, stock_valid, user_trader, headers)
        fulfill_order_buy!

        place_sell_order(order, stock_valid, user_trader, headers)
        fulfilled_order = fulfill_order_sell!
        expect(fulfilled_order.status).to eq('fulfilled')
      end

      it 'should update Portfolio for multiple buys of the same Stock' do
        headers = { Authorization: json['token'] }
        place_buy_order(order, stock_valid, user_trader, headers)
        fulfill_order_buy!

        place_buy_order(order, stock_valid, user_trader, headers)
        fulfill_order_buy!

        expect(Portfolio.first.total_quantity).to eq(6)
      end
    end
  end
end
