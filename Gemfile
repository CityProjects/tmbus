source 'https://rubygems.org'

ruby '1.9.3'  # need this for  http://mongoid.org/en/mongoid/docs/tips.html#ruby

gem 'rails', '3.2.8'

gem 'jquery-rails'

gem 'rake', '0.9.2.2' # good for heroku


gem 'mongoid', '~> 3.0.4'
gem 'mongoid_geospatial'


gem 'httparty', '~> 0.7'
gem 'nokogiri', '~> 1.5.5'

gem 'bcrypt-ruby', '~> 3.0.0'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', '~> 2.1.1'
end


group :development, :test do
  gem 'rspec-rails', '~> 2.11'
  gem 'factory_girl_rails', '~> 3.6'
  gem 'spork-rails'
  gem 'database_cleaner'
end


group :test do
  gem 'capybara', '>= 1.1.2'
  gem 'faker'
  gem 'launchy'
  gem 'webrat'
  gem 'resque_spec'
  gem 'database_cleaner'
end


group :production do
  gem 'unicorn'

  #gem 'newrelic_rpm'
  #gem 'rpm_contrib' # for resque newrelic instrumentation
end

