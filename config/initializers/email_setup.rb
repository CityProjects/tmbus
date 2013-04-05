ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mandrillapp.com",
  :port                 => 587,
  :domain               => "freetextmarketing.com",
  :user_name            => "admin@txtdlz.com",
  :password             => "f5c64bc0-7c77-4320-8e53-3379db184a40"
  #:authentication       => "plain",
  #:enable_starttls_auto => true
}


if Rails.env.production?
  ActionMailer::Base.default_url_options[:host] = "freetextmarketing.com"

elsif Rails.env.staging?
  ActionMailer::Base.default_url_options[:host] = "ftm-staging.herokuapp.com"

else
  ActionMailer::Base.default_url_options[:host] = "localhost:3000"

  if Rails.env.development?
    ActionMailer::Base.smtp_settings[:address] = 'localhost'
    ActionMailer::Base.smtp_settings[:port] = '1025'
  end
end


