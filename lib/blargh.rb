require 'fileutils'
require 'forwardable'
require 'yaml'

require 'sinatra'
require 'mustache'
require 'RedCloth'
require 'sinatra/mustache'
require 'stringex'
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
require 'blargh/query'
require 'blargh/server'
