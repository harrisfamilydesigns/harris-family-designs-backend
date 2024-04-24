class ThrifterSerializer < BaseSerializer

  def initialize(object)
    @thrifter = object
  end

  def attributes
    {
      id: @thrifter.id,
      user_id: @thrifter.user_id,
      address: @thrifter.address,
      preferences: @thrifter.preferences,
      experience_level: @thrifter.experience_level,
      bio: @thrifter.bio,
      avatar_url: @thrifter.avatar_url,
      status: @thrifter.status,
      stripe_account_id: @thrifter.stripe_account&.id,
    }
  end

end
