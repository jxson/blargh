require 'singleton'
require 'pathname'

module Blargh
  class << self
    def configure
      config = Blargh::Configuration.instance
      block_given? ? yield(config) : config
    end

    alias :config :configure
  end

  class Configuration
    include Singleton

    attr_reader :permalink
    attr_accessor :posts_directory, :root

    def initialize
      @posts_directory = Pathname.new('posts')
      @permalink = '/posts/:slug'
    end

    def root=(path)
      @root = Pathname.new(path)
    end

    def root
      @root || source_directory
    end

    def reset_root
      @root = nil
    end

    def posts_directory=(path)
      @posts_directory = Pathname.new(path)
    end

    private
    # These beautiful lines of code were inspired from a code snippet and
    # a detailed illustration of best practices for writing config files from
    # Gregory Brown's Practicing Ruby Newsletter:
    # http://letter.ly/practicing-ruby
    def source_directory(dir = Pathname.new('.'))
      config_ru = dir + 'config.ru'

      if dir.children.include?(config_ru)
        dir.expand_path
      else
        return pwd_with_warning if dir.expand_path.root?
        source_directory(dir.parent)
      end
    end

    def pwd_with_warning
      message = <<-NOTICE
# ============================================================================
# = WARNING!
# ============================================================================

While this isn't terrible news, something is kinda off about your Blargh. I am
forced to guess the location of your blog's source code beacuse you are
missing a config.ru and have not explicitly set your Blargh's root. You should
really try something like this:

  Blargh.config.root = File.expand_path('some/path')

      NOTICE

      Blargh.take_warning(message)

      Pathname.new(Dir.pwd)
    end
  end
end
