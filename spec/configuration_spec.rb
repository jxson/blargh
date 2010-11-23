require 'spec_helper'

describe Blargh, 'configuration' do
  before(:each) { silence_blargh_warnings }

  describe 'defaults' do
    its(:posts_directory) { should == 'posts' }
    its(:root) { should_not be_nil }
  end

  describe '.posts_directory' do
    before(:each) { Blargh.config.posts_directory = 'p' }

    its(:posts_directory) { should == 'p' }
  end

  let(:working_directory) { Pathname.new(File.expand_path('../', __FILE__)) }
  let(:source_path) { Pathname.new(File.expand_path('../source', __FILE__)) }
  let(:root) { Blargh.root }

  describe '.root' do
    before(:each) do
      Blargh.config.reset_root
      generate_source
      Dir.chdir(source_path)
    end

    after(:each) do
      Dir.chdir(working_directory)
      remove_source
    end

    context 'when the root is set' do
      before(:each) { Blargh.config.root = source_path }
      subject { root }

      it { should be_an_instance_of(Pathname) }
      it { should == source_path }

      context 'and there is no config.ru' do
        let(:some_random_path) { Pathname.new('random/path') }

        before(:each) do
          Blargh.config.root = some_random_path
          File.delete("#{ source_path }/config.ru")
        end

        it { should be_an_instance_of(Pathname) }
        it { should == some_random_path }
      end

      context 'as a string' do
        before(:each) { Blargh.config.root = source_path.to_s }
        subject { root }

        it { should be_an_instance_of(Pathname) }
        it { should == source_path }
      end
    end

    context 'when the root is not set' do
      subject { root }

      context 'and there is a config.ru' do
        it { should be_an_instance_of(Pathname) }
        it { should == source_path }
      end

      context 'and there is NO config.ru' do
        before(:each) do
          File.delete("#{ source_path }/config.ru")
          Blargh.should_receive(:take_warning)
        end

        it { should be_an_instance_of(Pathname) }
        it { should == source_path }
      end
    end
  end
end
