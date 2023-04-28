require 'rails_helper'

RSpec.describe 'Api::V1::Signup', type: :request do
  describe 'POST /api_v1_signup' do
    context 'with valid parameters' do
      before { @user = User.new }
      let(:user_trader) { build(:user, :trader) }

=begin
      before do
        # puts my_user_trader.email
        post '/api/v1/signup', params:
                          {
                            name: Faker::Name.name,
                            password: 'string',
                            password_confirmation: 'string',
                            email: "#{Faker::Alphanumeric.alpha(number: 10)}@strattonoakmont.com",
                            role: 'trader'
                          }
      end
=end
      before do
        post '/api/v1/signup', params:
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
  end
end
