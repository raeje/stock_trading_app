class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.integer :total_quantity
      t.timestamps
    end

    add_reference :portfolios, :users, foreign_key: true, null: false
    add_reference :portfolios, :stocks, foreign_key: true
    add_reference :portfolios, :orders, foreign_key: true
  end
end
