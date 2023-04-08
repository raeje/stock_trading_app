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
#
# Indexes
#
#  index_orders_on_stocks_id  (stocks_id)
#
# Foreign Keys
#
#  fk_rails_...  (stocks_id => stocks.id)
#
require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
