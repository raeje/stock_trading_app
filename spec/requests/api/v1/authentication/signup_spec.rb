require 'rails_helper'

RSpec.describe 'Api::V1::Signup', type: :request do
  describe 'POST /api_v1_signup' do
    context 'with valid parameters' do
      let(:user_trader) { build(:user, :trader) }

      before do
        post api_v1_signup_path, params:
          {
            name: user_trader.name,
            password: user_trader.password,
            password_confirmation: user_trader.password_confirmation,
            email: user_trader.email,
            role: user_trader.role
          }
      end

      it 'returns the message' do
        expect(json['message']).to eq('Account created.')
      end

      it 'works!' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid parameters' do
      let(:user_trader) { build(:user, :trader) }

      it 'return unprocessable entity if email is blank' do
        post api_v1_signup_path, params:
        {
          name: user_trader.name,
          password: user_trader.password,
          password_confirmation: user_trader.password_confirmation,
          email: '',
          role: user_trader.role
        }
        expect(response).to have_http_status(422)
      end

      it 'return unprocessable entity if passwords do no match' do
        post api_v1_signup_path, params:
        {
          name: user_trader.name,
          password: user_trader.password,
          password_confirmation: '123',
          email: user_trader.email,
          role: user_trader.role
        }
        expect(response).to have_http_status(422)
      end
    end
  end
end
