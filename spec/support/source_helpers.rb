module Blargh
  module SourceHelpers
    def source_path
      Pathname.new(File.expand_path('../../../tmp/spec-blargh.com', __FILE__))
    end

    def generate_source
      remove_source

      Blargh::Generators::New.start([
        source_path.to_s,
        '--verbose',
        'false'
      ])

      Blargh.config.root = source_path
    end

    def remove_source
      FileUtils.rm_rf(source_path)
    end

    def silence_blargh_warnings
      Blargh.stub!(:take_warning)
    end
  end
end