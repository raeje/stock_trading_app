# frozen_string_literal: true

# app/controllers/application_controller.rb
# Parent class for the controllers
class ApplicationController < ActionController::Base
  # Protect from cross site request forgery
  protect_from_forgery with: :null_session

  # Verify if token from request header is valid
  # if token is valid, authorize requests
  def authorize_request
    # Get Authorization from request headers
    header = request.headers['Authorization']
    header&.slice!(/(.* )?/)

    # Decode token
    # Throw errors if record not found or error at decoding token
    begin
      @decoded = JsonWebToken.decode(header)
      # Set current user
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize_admin_action
    return if @current_user.role == 'admin' && @current_user.is_approved

    render(json: { errors: ['Account not authorized to perform this action.'] }, status: :unauthorized)
  end

  def authorize_trader_action
    return if @current_user.role == 'trader' && @current_user.is_approved

    render(json: { errors: ['Account not authorized to perform this action.'] }, status: :unauthorized)
  end
end
