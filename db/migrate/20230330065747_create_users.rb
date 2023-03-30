class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :name
      t.string :token
      t.string :password_digest
      t.string :role
      t.boolean :is_approved, default: false
      t.decimal :balance, default: 0.0, precision: 10, scale: 2
      t.timestamps
    end
  end
end
