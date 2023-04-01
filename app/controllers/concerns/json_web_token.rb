# frozen_string_literal: true

# Static class for encoding/decoding token
class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  # Encode token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  # Decode token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
