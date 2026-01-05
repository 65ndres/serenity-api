class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!, unless: :public_endpoint?

  def authenticate_user!
    head :unauthorized unless authorized?
  end

  def authorized?
    token = request.headers['Authorization']&.split&.last
    return false unless token

    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      # Check if token is expired
      if payload['exp'] && Time.at(payload['exp']) > Time.now
        return true
      end
      # Token is expired
      return false
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      return false
    end
  end

  def current_user
    @current_user ||= begin
      token = request.headers['Authorization']&.split&.last
      return nil unless token

      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        User.find(payload['sub']) if authorized?
      rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
        nil
      end
    end
  end

  def public_endpoint?
    # Allow specific routes to be public

    request.path.match?(%r{^/api/v1/auth/(login|signup|password)$})
  end
end