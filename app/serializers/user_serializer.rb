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
      thrifter_id: @user.thrifter&.id,
    }
    if @user.admin?
      attributes[:admin] = @user.admin
    end
    attributes
  end

end
