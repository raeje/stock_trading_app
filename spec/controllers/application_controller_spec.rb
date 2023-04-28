# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'application_controller.rb', type: :request do
  describe 'user action authorization' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }

    before do
      login_as(user_admin)
      approve_user(user_trader, { Authorization: json['token'] })
      login_as(user_trader)
    end

    it 'should not work using trader account' do
      get api_v1_users_path, headers: { Authorization: json['token'] }
      expect(response).to have_http_status(401)
    end

    it 'should not work with deleted account' do
      User.find(user_trader.id).destroy
      get api_v1_stocks_path, headers: { Authorization: json['token'] }
      expect(response).to have_http_status(401)
    end

    it 'should not work with invalid token' do
      get api_v1_stocks_path, headers: { Authorization: user_trader.name }
      expect(response).to have_http_status(401)
    end
  end
end
