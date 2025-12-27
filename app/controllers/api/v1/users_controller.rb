class Api::V1::UsersController < ApplicationController
  def show
    if current_user
      render json: {
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        username: current_user.username
      }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def update
    if current_user
      if current_user.update(user_params)
        render json: {
          first_name: current_user.first_name,
          last_name: current_user.last_name,
          email: current_user.email,
          username: current_user.username,
          message: 'Profile updated successfully'
        }, status: :ok
      else
        render json: {
          errors: current_user.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def search
    query = params[:q]
    
    unless query.present?
      return render json: { error: 'Search query is required' }, status: :bad_request
    end

    users = User.search_by_username(query)
      .where.not(id: current_user.id)
      .limit(20)

    render json: {
      users: users.map do |user|
        {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name
        }
      end
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :username)
  end
end

