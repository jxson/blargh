require 'spec_helper'

describe Blargh, 'configuration' do
  describe 'defaults' do
    before(:each) { Blargh.configure }

    its(:posts_directory) { should == 'posts' }
    its(:root) { should be_nil }
  end

  describe '#posts_directory' do
    before(:each) do
      Blargh.configure do |config|
        config.posts_directory = 'p'
      end
    end

    its(:posts_directory) { should == 'p' }
  end

  describe '#root' do
    before(:each) do
      Blargh.configure do |config|
        config.root = '/somewhere'
      end
    end

    its(:root) { should == '/somewhere' }
  end
end
