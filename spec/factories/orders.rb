# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  category     :string           not null
#  expiry_date  :datetime
#  price        :decimal(10, 2)   default(0.0), not null
#  quantity     :integer          not null
#  status       :string           not null
#  traded_price :decimal(10, 2)   default(0.0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  stocks_id    :bigint           not null
#  users_id     :bigint           not null
#
# Indexes
#
#  index_orders_on_stocks_id  (stocks_id)
#  index_orders_on_users_id   (users_id)
#
# Foreign Keys
#
#  fk_rails_...  (stocks_id => stocks.id)
#  fk_rails_...  (users_id => users.id)
#
FactoryBot.define do
  factory :order do
    price { 123 }
    quantity { 3 }

    trait :buy do
      category { buy }
    end

    trait :sell do
      category { buy }
    end
  end
end
