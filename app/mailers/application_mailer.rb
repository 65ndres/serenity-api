class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_FROM', 'afre92@gmail.com')
  layout "mailer"
end
