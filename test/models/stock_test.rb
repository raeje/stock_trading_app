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
require "test_helper"

class StockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
