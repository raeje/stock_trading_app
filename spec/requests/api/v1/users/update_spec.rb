# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'PATCH /api/v1/users/:id' do
    let(:user_trader) { create(:user, :trader) }
    let(:user_admin) { create(:user, :admin) }

    before do
      login_as(user_admin)
      approve_user(user_trader, { Authorization: json['token'] })
    end
=begin
    context 'invalid parameters' do
      it 'should return status 422' do
        login_as(user_admin)
        User.find(user_trader.id).destroy
        patch "/api/v1/users/update/#{user_trader.id}", headers: { Authorization: json['token'] }
        expect(response).to have_http_status(422)
      end
    end
=end
  end
end
