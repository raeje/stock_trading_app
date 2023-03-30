# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin = User.create!(
  name: "Vito Corleone",
  email: "vito@godfather.com",
  password: "vitocorleone",
  role: "admin",
  is_approved: true,
  balance: 9999999.99,
  token: ""
)

trader_michael = User.create!(
  name: "Michael Corleone",
  email: "michael@godfather.com",
  password: "michaelcorleone",
  role: "trader",
  is_approved: true,
  balance: 10000.00,
  token: ""
)

trader_sonny = User.create!(
  name: "Sonny Corleone",
  email: "sonny@godfather.com",
  password: "sonnycorleone",
  role: "trader",
  is_approved: true,
  balance: 30123.08,
  token: ""
)