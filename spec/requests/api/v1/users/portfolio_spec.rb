# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /api/v1/users/portfolio' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }

    before do
      login_as(user_admin)
      approve_user(user_trader, { Authorization: json['token'] })
      login_as(user_trader)
    end

    it 'works!' do
      get api_v1_users_portfolio_path, headers: { Authorization: json['token'] }
      expect(response).to have_http_status(200)
    end
  end
end
