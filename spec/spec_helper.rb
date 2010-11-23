require 'blargh'
require 'shoulda'
require 'sparky'

require 'support/source_helpers'

RSpec.configure do |config|
  include Blargh::SourceHelpers
end

alias :doing :lambda

