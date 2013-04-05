require 'resque'
require 'resque/server'

# configure redis connection
if Rails.env.test?
  redis_uri = "redis://localhost:9736"
else
  # this will set by Heroku in production
  redis_uri = ENV["REDISTOGO_URL"] || "redis://localhost:6379"
end


uri = URI.parse(redis_uri)
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

# set a custom namespace for redis (optional)
Resque.redis.namespace = "resque:ltm"


Resque::Server.use(Rack::Auth::Basic) do |username, password|
  if Rails.env.development?
    true
  else
    username == AppConfig[:manage_username] && password == AppConfig[:manage_password]
  end
end


Resque.inline = Rails.env.test? || Rails.env.development?
