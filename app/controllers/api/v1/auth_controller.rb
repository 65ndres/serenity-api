class Api::V1::AuthController < ApplicationController
  include Devise::Controllers::Helpers

  # Skip authentication for public actions
  skip_before_action :authenticate_user!, only: [:login, :signup, :logout]

  def login
    user = User.find_for_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if user.save
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { token: token, user: { id: user.id, email: user.email } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    token = request.headers['Authorization']&.split&.last
    if token
      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        # Add token to denylist if it has a jti
        if payload['jti']
          JwtDenylist.create(jti: payload['jti'], exp: payload['exp'] ? Time.at(payload['exp']) : Time.now + 1.hour)
        end
        render json: { message: 'Logged out successfully' }, status: :ok
      rescue JWT::ExpiredSignature => e
        # Handle expired tokens gracefully - decode without verification to get jti
        begin
          require 'jwt'
          # Decode without verification to extract payload from expired token
          decoded = JWT.decode(token, nil, false)[0]
          if decoded['jti']
            JwtDenylist.create(jti: decoded['jti'], exp: decoded['exp'] ? Time.at(decoded['exp']) : Time.now + 1.hour)
          end
          render json: { message: 'Token expired, but logged out successfully' }, status: :ok
        rescue => decode_error
          # If we can't decode it at all, just return success (token is already invalid)
          render json: { message: 'Token expired' }, status: :ok
        end
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token: #{e.message}" }, status: :bad_request
      rescue StandardError => e
        render json: { error: "Failed to revoke token: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No token provided' }, status: :bad_request
    end
  end

end
