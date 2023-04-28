# == Schema Information
#
# Table name: stocks
#
#  id                :bigint           not null, primary key
#  company_name      :string
#  last_traded_price :decimal(10, 2)
#  logo              :string
#  quantity          :integer
#  ticker            :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :stock do
    trait :valid do
      company_name { Faker::Company.name }
      ticker { Faker::Alphanumeric.alpha(number: 4).upcase }
    end
  end
end
