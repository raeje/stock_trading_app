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
  validates(:email, presence: true, uniqueness: true)
  validates(:password, presence: true)

end
