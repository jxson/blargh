require 'thor'
require 'thor/group'

require 'blargh'
require 'blargh/generators/new'

module Blargh
  class CLI < Thor
    class_option :verbose, :default => true

    desc 'new [destination]', 'Generate a new blargh'
    def new(directory)
      Blargh::Generators::New.start([
        directory,
        '--verbose',
        options[:verbose]
      ])
    end
  end
end