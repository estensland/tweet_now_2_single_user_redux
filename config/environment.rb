# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require 'shotgun'

require 'erb'

require 'oauth'
require 'twitter'

require 'redis'
require 'sidekiq'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')

# Read credential yaml file
env_config = YAML.load_file(APP_ROOT.join('config', 'credentials.yaml'))

# Read credential vars into ENV
env_config.each do |key, value|
  ENV[key] = value
end

# Twitter.configure do |config|
#   config.consumer_key = ENV['TWITTER_KEY']
#   config.consumer_secret = ENV['TWITTER_SECRET']
# end

Twitter::REST::Client.new do |config|
  config.consumer_key         = ENV["consumer_key"]
  config.consumer_secret      = ENV["consumer_secret"]
  config.access_token         = ENV["access_token"]
  config.access_token_secret  = ENV["oauth_token_secret"]
end
