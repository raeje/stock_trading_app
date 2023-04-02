# frozen_string_literal: true

# == Schema Information
#
# Table name: stocks
#
#  id                :bigint           not null, primary key
#  company_name      :string
#  last_traded_price :decimal(10, 2)
#  logo              :string
#  quantity          :integer
#  ticker            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# app/models/stock.rb
class Stock < ApplicationRecord
end
