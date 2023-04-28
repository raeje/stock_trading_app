# == Schema Information
#
# Table name: portfolios
#
#  id             :bigint           not null, primary key
#  total_quantity :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  orders_id      :bigint
#  stocks_id      :bigint
#  users_id       :bigint           not null
#
# Indexes
#
#  index_portfolios_on_orders_id  (orders_id)
#  index_portfolios_on_stocks_id  (stocks_id)
#  index_portfolios_on_users_id   (users_id)
#
# Foreign Keys
#
#  fk_rails_...  (orders_id => orders.id)
#  fk_rails_...  (stocks_id => stocks.id)
#  fk_rails_...  (users_id => users.id)
#
class Portfolio < ApplicationRecord
  has_many :stocks

  scope :owned_by, ->(users_id) { where('users_id = ?', users_id) }

  def self.summary(users_id)
    where(users_id:)
  end
end
