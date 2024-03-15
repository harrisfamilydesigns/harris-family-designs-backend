class UserSerializer

  def initialize(user_object)
    @user = user_object
  end

  def json
    attributes = {
      id: @user.id,
      email: @user.email
    }
    if @user.admin?
      attributes[:admin] = @user.admin
    end
    attributes
  end

end
