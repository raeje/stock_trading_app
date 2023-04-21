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
  include ActiveModel::Dirty

  validates(:email, presence: true, uniqueness: true)
  validates(:password, presence: true, on: :create)

  before_update :update_balance_for_new_trader, :send_email_before_approval

  # [dev]
  def info
    p "user: #{id} balance: #{balance.to_f}"
    p Portfolio.where(users_id: id)
  end

  def update_balance_for_new_trader
    return unless role == 'trader'

    self.balance = 3000 if is_approved_changed?
  end

  def send_email_before_approval
    UserApprovedMailer.approved_email(self).deliver_now if is_approved_changed?
  end

  def self.encrypt_password(user_params)
    password_hash = Password.create(user_params[:password])
    create(email: user_params[:email], password: password_hash)
  end
end
