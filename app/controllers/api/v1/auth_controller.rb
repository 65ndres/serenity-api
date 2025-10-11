class Api::V1::AuthController < ApplicationController
  include Devise::Controllers::Helpers

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
      Warden::JWTAuth::TokenRevoker.new.revoke_token(token)
    end
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end