source 'https://rubygems.org'

ruby '1.9.3'  # need this for  http://mongoid.org/en/mongoid/docs/tips.html#ruby

gem 'rails', '3.2.6'

gem 'rake', '0.9.2.2' # good for heroku


gem 'mongoid', '~> 3.0.0'

gem 'jquery-rails'


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
end


group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails'
  gem 'capybara'
end


group :production do
  gem 'unicorn'
end

