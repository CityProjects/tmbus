source 'http://bundler-api.herokuapp.com'
source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.12'

gem 'jquery-rails', '~> 2.2.1'

gem 'rake', '10.0.4' # good for heroku

gem 'pg', '0.15.0'

gem 'dalli', '~> 2.6.2' # for memcache

gem 'resque', '~> 1.24.1'

gem 'httparty', '~> 0.10.2'
gem 'nokogiri', '~> 1.5.9'

gem 'gon', '~> 4.0.2'

gem 'jbuilder', '~> 1.2.0'

gem 'mobile-fu', '~> 1.1.1'

#gem 'mixpanel'



# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', '~> 0.11.4', platforms: :ruby
  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'compass-rails', '~> 1.0.3'
end


group :development, :test do
  gem 'rspec-rails', '~> 2.13'
  gem 'factory_girl_rails', '~> 4.2'
  gem 'database_cleaner'
  gem 'faker'
end


group :development do
  gem 'mailcatcher'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'thin'
end


group :test do
  #gem 'capybara', '>= 1.1.2'
end


group :production do
  gem 'unicorn', '~> 4.6.2'
  gem 'newrelic_rpm'
  #gem 'rpm_contrib' # for resque newrelic instrumentation
  gem 'memcachier'
end

