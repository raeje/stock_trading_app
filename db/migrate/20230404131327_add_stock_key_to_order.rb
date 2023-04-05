class AddStockKeyToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :stocks, foreign_key: true
  end
end
