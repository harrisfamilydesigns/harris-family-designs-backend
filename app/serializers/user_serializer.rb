class UserSerializer < BaseSerializer

  def initialize(user_object)
    @user = user_object
  end

  def attributes
    attributes = {
      id: @user.id,
      email: @user.email,
      first_name: @user.first_name,
      last_name: @user.last_name,
      confirmed: @user.confirmed?,
      unconfirmed_email: @user.unconfirmed_email,
      address: @user.address,
      preferences: @user.preferences
    }
    if @user.admin?
      attributes[:admin] = @user.admin
    end
    attributes
  end

end
