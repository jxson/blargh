require 'spec_helper'

describe Blargh::Post do
  # https://gist.github.com/665629
  describe 'ActiveModel Lint tests' do
    require 'test/unit/assertions'
    require 'active_model/lint'

    include Test::Unit::Assertions
    include ActiveModel::Lint::Tests

    ActiveModel::Lint::Tests.
      public_instance_methods.
      map { |m| m.to_s }.
      grep(/^test/).each { |m| example(m.gsub('_',' ')) { send(m) } }

    def model
      Blargh::Post.new
    end
  end # describe 'ActiveModel Lint tests'
end
