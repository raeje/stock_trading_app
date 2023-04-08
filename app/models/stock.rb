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
#  ticker            :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Stock < ApplicationRecord
  # scope :find_id_by_ticker, ->(ticker) { where('ticker = ?', ticker).pluck(:id)[0] }

  def iex_api_key
    ENV['IEX_API_PUBLISHABLE_TOKEN']
  end

  def self.find_id_by_ticker(ticker)
    where('ticker = ?', ticker).pluck(:id)[0]
  end

  def self.quote(ticker)
    api_data = { key: ENV['IEX_API_PUBLISHABLE_TOKEN'] }
    quote = RestClient.get("https://api.iex.cloud/v1/data/core/quote/#{ticker}?token=#{api_data[:key]}")
    JSON.parse(quote)[0]
  end

  def self.batch_quote(limit, offset)
    batch = URI.encode_uri_component(limit(limit).offset(offset).pluck(:ticker).join(','))
    api_data = { key: ENV['IEX_API_PUBLISHABLE_TOKEN'] }
    quote = RestClient.get("https://api.iex.cloud/v1/data/core/quote/#{batch}?token=#{api_data[:key]}")
    JSON.parse(quote)
  end

  def self.latest_price(ticker)
    start_time = Time.now
    api_data = { key: ENV['IEX_API_PUBLISHABLE_TOKEN'] }
    quote = RestClient.get("https://api.iex.cloud/v1/data/core/quote/#{ticker}?token=#{api_data[:key]}")
    ticker_quote = JSON.parse(quote)[0]
    ticker_quote['latestPrice']
    { latest_price: ticker_quote['latestPrice'], elapsed: Time.now - start_time }
  end

  def self.monitor_price(ticker, limit)
    start_time = Time.now
    for i in 1..limit do
      p i
      p latest_price(ticker)
    end
    { elapsed: Time.now - start_time }
  end

  def self.quote_all(limit)
    batch = limit(limit).pluck(:ticker).join(',')

    api_data = { key: ENV['IEX_API_PUBLISHABLE_TOKEN'] }
    quote = RestClient.get("https://api.iex.cloud/v1/data/core/quote/#{batch}?token=#{api_data[:key]}")
    JSON.parse(quote)
  end
end
