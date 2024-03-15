module FrontendUrls
  def self.confirmation_url(token)
    "#{url}/email/confirm?token=#{token}"
  end

  def self.password_reset_url(token)
    "#{url}/password/reset?token=#{token}"
  end

  private

  def self.config
    Rails.application.config.frontend_urls[Rails.env]
  end

  def self.url
    if Rails.env.development?
      "#{config['secondhand']}:#{config['port']}"
    else
      config['secondhand']
    end
  end

  # Add more custom URL helper methods as needed
end
