# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /api/v1/users/new' do
    let(:user_trader) { build(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }

    before do
      login_as(user_admin)
    end

    it 'works!' do
      post api_v1_users_new_path, params: { email: user_trader.email,
                                            password: user_trader.password,
                                            password_confirmation: user_trader.password_confirmation,
                                            role: user_trader.role },
                                  headers: { Authorization: json['token'] }
      expect(response).to have_http_status(201)
    end

    context 'invalid parameters' do
      it 'should return status unprocessable entity' do
        post api_v1_users_new_path, params: { email: '',
                                              password: user_trader.password,
                                              password_confirmation: user_trader.password_confirmation,
                                              role: user_trader.role },
                                    headers: { Authorization: json['token'] }
        expect(response).to have_http_status(422)
      end
    end
  end
end
