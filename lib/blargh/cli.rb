require 'blargh/generators/new'

module Blargh
  class CLI < Thor
    desc 'new [destination]', 'Generate a new blargh'
    def new(directory)
      Blargh::Generators::New.start([directory])
    end
  end
end