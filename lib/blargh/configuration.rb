require "singleton"

module Blargh
  class << self
    def configure
      config = Blargh::Configuration.instance
      block_given? ? yield(config) : config
    end

    alias :config :configure

    def posts_directory
      configure.posts_directory
    end

    def root
      configure.root
    end
  end

  class Configuration
    include Singleton

    attr_accessor :posts_directory, :root

    def initialize
      @posts_directory = 'posts'
    end
  end
end
