class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  # skip_before_action :authenticate
  # respond_to :json


  def respond_with(current_user, _opts = {})
    # render json: {
    #   status: { 
    #     code: 200, message: 'Logged in successfully.',
    #     data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
    #   }
      # render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok

    user = User.find_for_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def destroy
    # if request.headers['Authorization'].present?
    #   jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, 'eb3e132bf10c38cd874a0a25eaef0907902473a50c1ae7b816f6caf13bb53f3a84ab43bcb8b8d891202cc3299d8d230a8e90335c7cf2c3ccf883a0c4e8e8f28c').first
    #   current_user = User.find(jwt_payload['sub'])
    # end
    
    # if current_user
    #   render json: {
    #     status: 200,
    #     message: 'Logged out successfully.'
    #   }, status: :ok
    # else
    #   render json: {
    #     status: 401,
    #     message: "Couldn't find an active session."
    #   }, status: :unauthorized
    # end
    token = request.headers['Authorization']&.split&.last
    if token
      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        if payload['exp'] && Time.at(payload['exp']) < Time.now
          render json: { error: 'Token has expired' }, status: :unauthorized
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