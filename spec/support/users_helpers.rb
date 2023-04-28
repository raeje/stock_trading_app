# frozen_string_literal: true

module UsersHelpers
  def approve_user(user, headers)
    patch "/api/v1/users/update/#{user.id}", params: { is_approved: true }, headers:
  end
end
