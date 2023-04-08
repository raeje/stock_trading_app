# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'rest-client'

start_time = Time.now
p 'Seeding Users..'

admin = User.create!(
  name: 'Vito Corleone',
  email: 'vito@godfather.com',
  password: 'vitocorleone',
  role: 'admin',
  is_approved: true,
  balance: 9_999_999.99,
  token: ''
)

trader_michael = User.create!(
  name: 'Michael Corleone',
  email: 'michael@godfather.com',
  password: 'michaelcorleone',
  role: 'trader',
  is_approved: true,
  balance: 10_000.00,
  token: ''
)

trader_sonny = User.create!(
  name: 'Sonny Corleone',
  email: 'sonny@godfather.com',
  password: 'sonnycorleone',
  role: 'trader',
  is_approved: true,
  balance: 30_123.08,
  token: ''
)

trader_sonny = User.create!(
  name: 'Fredo Corleone',
  email: 'fredo@godfather.com',
  password: 'fredocorleone',
  role: 'trader',
  is_approved: true,
  balance: 3.33,
  token: ''
)

p "elapsed: #{Time.now - start_time}"

start_time = Time.now
p 'Seeding Stocks..'

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

p "elapsed: #{Time.now - start_time}"

start_time = Time.now
p 'Seeding Orders..'

Order.create!(
  price: 123.08,
  quantity: 80,
  status: 'placed',
  category: 'buy',
  stocks_id: 1,
  users_id: 4
)

Order.create!(
  price: 40.33,
  quantity: 10,
  status: 'placed',
  category: 'buy',
  stocks_id: 2,
  users_id: 2
)

Order.create!(
  price: 23,
  quantity: 30,
  status: 'placed',
  category: 'buy',
  stocks_id: 3,
  users_id: 3
)

Order.create!(
  price: 1.2,
  quantity: 800,
  status: 'placed',
  category: 'buy',
  stocks_id: 8,
  users_id: 4,
  users_id: 2
)

Order.create!(
  price: 20,
  quantity: 60,
  status: 'placed',
  category: 'buy',
  stocks_id: 321,
  users_id: 3,
  users_id: 3
)

Order.create!(
  price: 20,
  quantity: 50,
  status: 'placed',
  category: 'buy',
  stocks_id: 321,
  users_id: 2,
  users_id: 4
)

Order.create!(
  price: 15.5,
  quantity: 10,
  status: 'placed',
  category: 'buy',
  stocks_id: 123,
  users_id: 4
)

Order.create!(
  price: 15.99,
  quantity: 18,
  status: 'placed',
  category: 'buy',
  stocks_id: 300,
  users_id: 8
)

Order.create!(
  price: 123.08,
  quantity: 8,
  status: 'placed',
  category: 'sell',
  stocks_id: 3,
  users_id: 3
)

Order.create!(
  price: 123.08,
  quantity: 8,
  status: 'fulfilled',
  category: 'buy',
  stocks_id: 3,
  users_id: 2
)

Order.create!(
  price: 123.08,
  quantity: 80,
  status: 'placed',
  category: 'buy',
  stocks_id: 1,
  users_id: 3
)

p "elapsed: #{Time.now - start_time}"
