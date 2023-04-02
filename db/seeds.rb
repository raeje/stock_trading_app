# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'rest-client'

admin = User.create!(
  name: 'Vito Corleone',
  email: 'vito@godfather.com',
  password: 'vitocorleone',
  role: 'admin',
  is_approved: true,
  balance: 9999999.99,
  token: ''
)

trader_michael = User.create!(
  name: 'Michael Corleone',
  email: 'michael@godfather.com',
  password: 'michaelcorleone',
  role: 'trader',
  is_approved: true,
  balance: 10000.00,
  token: ''
)

trader_sonny = User.create!(
  name: 'Sonny Corleone',
  email: 'sonny@godfather.com',
  password: 'sonnycorleone',
  role: 'trader',
  is_approved: true,
  balance: 30123.08,
  token: ''
)

def iex_api_key
  ENV['IEX_API_PUBLISHABLE_TOKEN']
end

def stock_dataset
  api_data = { key: iex_api_key }
  stocks = RestClient.get("https://api.iex.cloud/v1/data/CORE/REF_DATA_IEX_SYMBOLS?token=#{api_data[:key]}")
  stocks_array = JSON.parse(stocks)
  stocks_array.each do |s|
    Stock.create(ticker: s['symbol'], company_name: s['name'])
  end
end

stock_dataset
