class Api::V1::PasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  # Request password reset - sends code to email
  def create
    email = params[:email]
    
    unless email.present?
      return render json: { error: 'Email is required' }, status: :bad_request
    end

    user = User.find_by(email: email)
    
    if user
      # Generate 6-digit code
      code = generate_reset_code
      
      # Store code in reset_password_token (Devise field) and timestamp
      user.update(
        reset_password_token: code,
        reset_password_sent_at: Time.now
      )
      
      # Send email with code
      PasswordResetMailer.reset_code(user, code).deliver_now
      
      render json: { 
        message: 'If an account with that email exists, you will receive a password reset code.' 
      }, status: :ok
    else
      # Don't reveal if email exists for security
      render json: { 
        message: 'If an account with that email exists, you will receive a password reset code.' 
      }, status: :ok
    end
  end

  # Verify the reset code
  def verify_code
    email = params[:email]
    code = params[:code]
    
    unless email.present? && code.present?
      return render json: { error: 'Email and code are required' }, status: :bad_request
    end

    user = User.find_by(email: email)
    
    unless user
      return render json: { error: 'Invalid email or code' }, status: :unauthorized
    end

    # Check if code matches and is not expired (1 hour)
    if user.reset_password_token == code && 
       user.reset_password_sent_at && 
       user.reset_password_sent_at > 1.hour.ago
      render json: { 
        message: 'Code verified successfully',
        reset_token: user.reset_password_token # Return token for password reset
      }, status: :ok
    else
      render json: { error: 'Invalid or expired code' }, status: :unauthorized
    end
  end

  # Reset password with verified code
  def update
    email = params[:email]
    code = params[:code] || params[:reset_token]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    
    unless email.present? && code.present?
      return render json: { error: 'Email and code are required' }, status: :bad_request
    end

    unless password.present?
      return render json: { error: 'Password is required' }, status: :bad_request
    end

    unless password == password_confirmation
      return render json: { error: 'Password confirmation does not match' }, status: :unprocessable_entity
    end

    user = User.find_by(email: email)
    
    unless user
      return render json: { error: 'Invalid email or code' }, status: :unauthorized
    end

    # Verify code again before resetting
    unless user.reset_password_token == code && 
           user.reset_password_sent_at && 
           user.reset_password_sent_at > 1.hour.ago
      return render json: { error: 'Invalid or expired code' }, status: :unauthorized
    end

    # Use Devise's password assignment
    user.password = password
    user.password_confirmation = password_confirmation
    
    if user.save
      # Clear the reset token
      user.update(reset_password_token: nil, reset_password_sent_at: nil)
      
      render json: { 
        message: 'Password has been reset successfully' 
      }, status: :ok
    else
      render json: { 
        errors: user.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  private

  def generate_reset_code
    # Generate a 6-digit code
    rand(100000..999999).to_s
  end
end

