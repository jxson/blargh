module Blargh
  module SourceHelpers
    def souce_path
      Pathname.new(File.expand_path('../../source', __FILE__))
    end

    def template_path
      path = File.expand_path('../../../lib/blargh/generators/new', __FILE__)
      Pathname.new(path)
    end

    def generate_source
      remove_source
      FileUtils.cp_r(template_path, souce_path)
    end

    def remove_source
      FileUtils.rm_rf(souce_path)
    end

    def silence_blargh_warnings
      Blargh.stub!(:take_warning)
    end
  end
end