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
        if payload['exp'] && Time.at(payload['exp']) < Time.now
          render json: { error: 'Token has expired' }, status: :ok
        else
          JwtDenylist.create(jti: payload['jti'], exp: Time.at(payload['exp'])) if payload['jti']
          render json: { message: 'Logged out successfully' }, status: :ok
        end
      rescue JWT::DecodeError, JWT::ExpiredSignature => e
        render json: { error: "Invalid or expired token: #{e.message}" }, status: :unauthorized
      rescue StandardError => e
        render json: { error: "Failed to revoke token: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No token provided' }, status: :bad_request
    end
  end

end
