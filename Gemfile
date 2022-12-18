# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'rails', '~> 7.0.4'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rubocop', '~> 1.40.0'
gem 'tzinfo-data'

gem 'bootsnap', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem "kaminari", "~> 1.2"
