class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!, unless: :public_endpoint?

  def authenticate_user!
    head :unauthorized unless current_user
  end

  def public_endpoint?
    # Allow specific routes to be public
    request.path.match?(%r{^/api/v1/auth/(login|signup|password)$})
  end
end