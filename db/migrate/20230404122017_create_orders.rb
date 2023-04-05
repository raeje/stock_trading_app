class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status, null: false
      t.string :category, null: false
      t.integer :quantity, null: false
      t.decimal :price, default: 0.0, precision: 10, scale: 2, null: false
      t.datetime :expiry_date
      t.timestamps
    end
  end
end
