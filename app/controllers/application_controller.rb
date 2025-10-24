class ApplicationController < ActionController::API
  # before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate

  include Devise::Controllers::Helpers

  # Skip authentication for public actions
  

  # rescue_from JWT::VerificationError, with: :invalid_token
  # rescue_from JWT::DecodeError, with: :decode_error

  private

  def authenticate
    # binding.irb
    # token = request.headers['Authorization']&.split&.last
    # payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    # if payload['exp'] && Time.at(payload['exp']) < Time.now
    #       render json: { error: 'Token has expired' }, status: :unauthorized
    # end
    # authorization_header = request.headers['Authorization']
    # token = authorization_header.split(" ").last if authorization_header
    # decoded_token = JsonWebToken.decode(token)
    
    # User.find(decoded_token[:user_id])
  end

  def invalid_token
    render json: { invalid_token: 'invalid token' }
  end

  def decode_error
    render json: { decode_error: 'decode error' }
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end
end


