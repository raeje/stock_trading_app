# frozen_string_literal: true

# Create Stocks table
class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :ticker
      t.string :company_name
      t.decimal :last_traded_price, precision: 10, scale: 2
      t.integer :quantity
      t.string :logo
      t.timestamps
    end
  end
end
