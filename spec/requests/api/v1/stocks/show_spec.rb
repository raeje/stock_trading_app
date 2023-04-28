# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Stocks', type: :request do
  describe 'GET /api/v1/stocks/:id' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }
    let(:stock_valid) { create(:stock, :valid) }

    it 'works!' do
      login_as(user_admin)
      get "/api/v1/stocks/#{stock_valid.id}", headers: { Authorization: json['token'] }
      expect(response).to have_http_status(200)
    end
  end
end
