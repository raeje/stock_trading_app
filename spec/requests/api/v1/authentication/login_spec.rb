# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Login', type: :request do
  describe 'POST /api_v1_login' do
    context 'with valid parameters' do
      let(:user_trader) { create(:user, :trader) }
      let(:user_admin) { create(:user, :admin) }
      current_user = ''

      before do
        login_as(user_admin)
        approve_user(user_trader, { Authorization: json['token'] })
        current_user = User.find(user_trader.id)
      end

      it 'sets trader is_approved to true' do
        expect(current_user.is_approved).to eq(true)
      end

      it 'returns trader balance equal to 3000' do
        expect(current_user.balance).to eq(3000)
      end

      it 'returns update confirmation message' do
        expect(json['message']).to eq("User #{current_user.email} updated.")
      end

      it 'works!' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid parameters' do
      let(:user_trader) { create(:user, :trader) }
      let(:user_admin) { create(:user, :admin) }

      before do
        login_as(user_admin)
        approve_user(user_trader, { Authorization: json['token'] })
      end

      it 'returns unauthorized error if email and password are blank' do
        put api_v1_login_path, params: { email: '', password: '' }
        expect(response).to have_http_status(401)
      end

      it 'returns unauthorized error if password is incorrect' do
        put api_v1_login_path, params: { email: user_trader.email, password: '123' }
        expect(response).to have_http_status(404)
      end
    end
  end
end
