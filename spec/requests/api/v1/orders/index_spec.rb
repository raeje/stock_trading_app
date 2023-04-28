# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  describe 'GET /api/v1/orders' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }

    before do
      login_as(user_admin)
      patch "/api/v1/users/update/#{user_trader.id}", params: { is_approved: true },
                                                      headers: { Authorization: json['token'] }
    end

    context 'with admin account' do
      it 'works!' do
        login_as(user_admin)
        get api_v1_orders_path, headers: { Authorization: json['token'] }
        expect(response).to have_http_status(200)
      end
    end

    context 'with trader account' do
      it 'returns status 401, unauthorized' do
        login_as(user_trader)
        get api_v1_orders_path, headers: { Authorization: json['token'] }
        expect(response).to have_http_status(401)
      end
    end
  end
end
