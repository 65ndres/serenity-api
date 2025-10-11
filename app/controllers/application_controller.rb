class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!, unless: :public_endpoint?

  def authenticate_user!
    head :unauthorized unless current_user
  end

  def public_endpoint?
    # Define public routes if needed (e.g., public verses)
    false
  end
end