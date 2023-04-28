# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  describe 'POST /api/v1/orders/new' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }
    let(:stock_valid) { create(:stock, :valid) }
    let(:order_buy) { build(:order) }

    before do
      login_as(user_admin)
      approve_user(user_trader, { Authorization: json['token'] })
      login_as(user_trader)
    end

    context 'valid parameters' do
      it 'works!' do
        place_buy_order(order_buy, stock_valid, user_trader, { Authorization: json['token'] })
        expect(response).to have_http_status(201)
      end
    end

    context 'admin places an order' do
      it 'returns unauthorized status' do
        login_as(user_admin)
        place_buy_order(order_buy, stock_valid, user_trader, { Authorization: json['token'] })
        expect(response).to have_http_status(401)
      end
    end
  end
end
