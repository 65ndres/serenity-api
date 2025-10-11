# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end