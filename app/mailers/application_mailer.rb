class ApplicationMailer < ActionMailer::Base
  default(
    from: "info@harrisfamilydesigns.com",
    reply_to: "info@harrisfamilydesigns.com",
  )
  layout "mailer"
end
