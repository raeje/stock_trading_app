# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Stocks', type: :request do
  describe 'POST /api/v1/stocks/new' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }
    let(:stock_valid) { build(:stock, :valid) }

    context 'valid parameters' do
      it 'works!' do
        login_as(user_admin)
        post '/api/v1/stocks/new', params: { company_name: stock_valid.company_name, ticker: stock_valid.ticker },
                                   headers: { Authorization: json['token'] }
        expect(response).to have_http_status(201)
      end
    end
  end
end
