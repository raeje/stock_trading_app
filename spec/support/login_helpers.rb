# frozen_string_literal: true

module LoginHelpers
  def login_as(user)
    puts '==============================================='
    puts '  LoginHelpers'
    puts "  Name: #{user.name}"
    puts "  Email: #{user.email}"
    puts "  Role: #{user.role}"
    put '/api/v1/login', params: { email: user.email, password: user.password }
  end
end
