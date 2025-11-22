class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!, unless: :public_endpoint?

  def authenticate_user!
    head :unauthorized unless authorized?
  end



  def authorized?
    token = request.headers['Authorization']&.split&.last
    if token
      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        if payload['exp'] && Time.at(payload['exp']) > Time.now
          return true
        end
      rescue JWT::DecodeError, JWT::ExpiredSignature => e
        return false
      end
    end

    false
  end

  def public_endpoint?
    # Allow specific routes to be public

    request.path.match?(%r{^/api/v1/auth/(login|signup|password)$})
  end
end