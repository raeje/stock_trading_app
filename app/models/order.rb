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
class Order < ApplicationRecord
  include ActiveModel::Dirty

  validates(:category, :price, :quantity, :status, :stocks_id, :users_id, presence: true)

  validate :balance_cannot_be_less_than_total_price, :total_quantity_cannot_be_less_than_quantity, on: :create
  # validate :fulfilled_order_cannot_be_modified, on: :update

  scope :placed, -> { where(status: 'placed') }
  scope :placed_buy, -> { placed.where(category: 'buy') }
  scope :placed_sell, -> { placed.where(category: 'sell') }

  after_create :update_related_tables
  after_update :update_related_tables

  # [prod] for background updates
  def self.fulfill(price)
    # Find buy orders
    buy = placed_buy.where(['price >= ?', price])
    buy.each do |buy_order|
      buy_order.update(status: 'fulfilled', traded_price: price)
    end
    # buy.update_all(status: 'fulfilled', traded_price: price)

    sell = placed_sell.where(['price <= ?', price])
    sell.each do |sell_order|
      sell_order.update(status: 'fulfilled', traded_price: price)
    end
    # sell.update_all(status: 'fulfilled', traded_price: price)
  end

  # [dev]
  def fulfill
    update(status: 'fulfilled')
  end

  # Throw error if
  # user is updating a fulfilled order
  def fulfilled_order_cannot_be_modified
    status_changed_to_fulfilled = status_previously_changed?(from: 'fulfilled', to: 'placed')
    errors.add(:status, "can't modify fulfilled orders") if status_changed_to_fulfilled
  end

  # Throw error if
  # BUY and User.balance < Order.quantity * Order.price
  def balance_cannot_be_less_than_total_price
    user = User.find(users_id)
    if user.balance < (quantity * price) && category == 'buy'
      errors.add(:balance, "can't be less than total price")
    end
  end

  # Throw error if
  # SELL and Portfolio.total_quantity < Order.quantity
  def total_quantity_cannot_be_less_than_quantity
    return unless category == 'sell'

    portfolio_stocks = Portfolio.where(users_id:, stocks_id:).limit(1)[0]
    total_quantity = portfolio_stocks.nil? ? 0 : portfolio_stocks.total_quantity
    if total_quantity < quantity && category == 'sell'
      errors.add(:total_quantity, "can't be less than order quantity")
    end
  end

  # PLACED SELL
  # update portfolio -
  def update_when_placed_sell
    return unless placed && sell

    total_quantity = portfolio_stocks.total_quantity - quantity
    portfolio_stocks.update(total_quantity:)
  end

  # FULFILLED BUY
  # CANCELLED SELL
  # update portfolio +
  def update_when_fulfilled_buy_or_cancelled_sell
    return unless (buy && fulfilled) || (sell && cancelled)

    if portfolio_stocks.nil?
      Portfolio.create!(stocks_id:, users_id:, total_quantity: quantity)
      return
    end
    total_quantity = portfolio_stocks.total_quantity + quantity
    portfolio_stocks.update(total_quantity:)
  end

  # PLACED BUY
  # update balance -
  def update_when_placed_buy
    return unless placed && buy

    user = User.find(users_id)
    total_price = quantity * price
    user.update(balance: user.balance - total_price)
  end

  # FULFILLED SELL
  # CANCELLED BUY
  # update balance +
  def update_when_fulfilled_sell_or_cancelled_buy
    return unless (fulfilled && sell) || (cancelled && buy)

    user = User.find(users_id)
    total_price = quantity * price
    user.update(balance: user.balance + total_price)
  end

  def update_related_tables
    # return unless status_changed?
    # Portfolio updates
    update_when_fulfilled_buy_or_cancelled_sell
    update_when_placed_sell

    # User balance updates
    update_when_fulfilled_sell_or_cancelled_buy
    update_when_placed_buy

    User.find(users_id).info
  end

  private

  def portfolio_stocks
    Portfolio.where(users_id:, stocks_id:).limit(1)[0]
  end

  def sell
    category == 'sell'
  end

  def buy
    category == 'buy'
  end

  def placed
    status == 'placed'
  end

  def fulfilled
    status == 'fulfilled'
  end

  def cancelled
    status == 'cancelled'
  end
end
