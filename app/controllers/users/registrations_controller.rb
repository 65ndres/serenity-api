class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json
  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
      render json: { token: token, user: { id: resource.id, email: resource.email } }, status: :created
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end