# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }

    before do
      login_as(user_admin)
      approve_user(user_trader, { Authorization: json['token'] })
    end

    it 'should work using admin account' do
      login_as(user_admin)
      get api_v1_users_path, headers: { Authorization: json['token'] }
      expect(response).to have_http_status(200)
    end

    it 'should not work using trader account' do
      login_as(user_trader)
      get api_v1_users_path, headers: { Authorization: json['token'] }
      expect(response).to have_http_status(401)
    end
  end
end
