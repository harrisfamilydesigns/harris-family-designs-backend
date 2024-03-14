class UserSerializer

  def initialize(user_object)
    @user = user_object
  end

  def json
    @user.to_json(only: [:id, :email])
  end

end
