# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  balance         :decimal(10, 2)   default(0.0)
#  email           :string
#  is_approved     :boolean          default(FALSE)
#  name            :string
#  password        :string
#  password_digest :string
#  role            :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }

    trait :admin do
      role { 'admin' }
      email { 'vito@godfather.com' }
      password { 'vitocorleone' }
      password_confirmation { 'vitocorleone' }
      is_approved { true }
    end

    trait :trader do
      role { 'trader' }
      email { "#{Faker::Alphanumeric.alpha(number: 10)}@strattonoakmont.com" }
      password { 'MyString' }
      password_confirmation { 'MyString' }
    end

    # factory :user_admin, traits: [:admin]
    factory :user_trader, traits: [:trader]
  end
end
