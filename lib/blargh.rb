require 'fileutils'
require 'yaml'

require 'sinatra'
require 'mustache'
require 'mustache/sinatra'
require 'stringex'
require 'thor'
require 'thor/group'
require 'active_model'
require 'active_support/core_ext'

module Blargh
  class << self
    def take_warning(message)
      warn(message)
    end
  end
end

require 'blargh/version'
require 'blargh/configuration'
require 'blargh/post'
require 'blargh/post/attributes'
require 'blargh/post/conversion'
require 'blargh/post/finders'
require 'blargh/post/persistence'
require 'blargh/server'
