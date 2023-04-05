# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  category    :string           not null
#  expiry_date :datetime
#  price       :decimal(10, 2)   default(0.0), not null
#  quantity    :integer          not null
#  status      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  stocks_id   :bigint
#
# Indexes
#
#  index_orders_on_stocks_id  (stocks_id)
#
# Foreign Keys
#
#  fk_rails_...  (stocks_id => stocks.id)
#
class Order < ApplicationRecord
  scope :placed, -> { where(status: 'placed') }
  scope :placed_buy, -> { placed.where(category: 'buy') }
  scope :placed_sell, -> { placed.where(category: 'sell') }

  def self.fulfill(stocks_id, price)
    orders = placed_buy.where(['stocks_id = ? and price <= ?', stocks_id, price])
    orders.update_all(status: 'fulfilled')
  end
end
