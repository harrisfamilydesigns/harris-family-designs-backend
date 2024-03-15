class EmailInterceptor
  def self.delivering_email(message)
    message.to = ['max@harrisfamilydesigns.com']
    message.cc = nil
    message.bcc = nil
  end
end
