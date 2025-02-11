class UserService
  def self.user_exists?(params)
    return User.exists?(email: params["email"])
  end
end
