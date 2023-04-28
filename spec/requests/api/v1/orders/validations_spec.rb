# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  describe 'Order validations' do
    context 'verify order validations' do
      let(:user_trader) { create(:user, :trader) }
      let(:user_admin) { create(:user, :admin) }
      let(:stock_valid) { create(:stock, :valid) }
      let(:order) { build(:order) }

      before do
        login_as(user_admin)
        approve_user(user_trader, { Authorization: json['token'] })
        login_as(user_trader)
      end

      it 'should return an error when balance is less than total_price' do
        place_invalid_buy_order(order, stock_valid, user_trader, { Authorization: json['token'] })
        expect(response.body).to eq("{\"errors\":{\"balance\":[\"can't be less than total price\"]}}")
      end

      it 'should return an error when SELL and Portfolio.total_quantity is less than Order.quantity' do
        place_sell_order(order, stock_valid, user_trader, { Authorization: json['token'] })
        expect(response.body).to eq("{\"errors\":{\"total_quantity\":[\"can't be less than order quantity\"]}}")
      end
    end
  end
end
