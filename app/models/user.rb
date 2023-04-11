# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  balance         :decimal(10, 2)   default(0.0)
#  email           :string
#  is_approved     :boolean          default(FALSE)
#  name            :string
#  password        :string
#  password_digest :string
#  role            :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  # Add methods to set and authenticate against a BCrypt password.
  has_secure_password
  include BCrypt

  validates(:email, presence: true, uniqueness: true)
  validates(:password, presence: true, on: :create)

  # [dev]
  def info
    p "user: #{id} balance: #{balance.to_f}"
    p Portfolio.where(users_id: id)
  end

  def self.encrypt_password(user_params)
    password_hash = Password.create(user_params[:password])
    create(email: user_params[:email], password: password_hash)
  end
end
