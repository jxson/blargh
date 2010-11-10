require 'blargh'
require 'shoulda'
require 'sparky'

alias :doing :lambda

Blargh.configure do |config|
  config.posts_directory = 'posts'
  config.root = File.expand_path('../', __FILE__)
end
