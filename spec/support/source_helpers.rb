module Blargh
  module SourceHelpers
    def souce_path
      Pathname.new(File.expand_path('../../../tmp/source', __FILE__))
    end

    def generate_source
      remove_source

      Blargh::Generators::New.start([
        souce_path.to_s,
        '--verbose',
        'false'
      ])

      Blargh.config.root = souce_path
    end

    def remove_source
      FileUtils.rm_rf(souce_path)
    end

    def silence_blargh_warnings
      Blargh.stub!(:take_warning)
    end
  end
end