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
#  stocks_id    :bigint
#  users_id     :bigint
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
class Order < ApplicationRecord
  scope :placed, -> { where(status: 'placed') }
  scope :placed_buy, -> { placed.where(category: 'buy') }
  scope :placed_sell, -> { placed.where(category: 'sell') }

  validates(:category, :price, :quantity, :status, :stocks_id, :users_id, presence: true)

  def self.fulfill(price)
    # Find buy orders
    buy = placed_buy.where(['price <= ?', price])
    buy.update_all(status: 'fulfilled', traded_price: price)

    sell = placed_sell.where(['price >= ?', price])
    sell.update_all(status: 'fulfilled', traded_price: price)
  end
end
