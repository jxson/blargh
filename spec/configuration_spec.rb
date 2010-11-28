require 'spec_helper'

describe Blargh, 'configuration' do
  before(:each) { silence_blargh_warnings }

  let(:working_directory) { Pathname.new(File.expand_path('../', __FILE__)) }
  let(:source_path) { Pathname.new(File.expand_path('../source', __FILE__)) }

  describe 'defaults' do
    subject { Blargh.config }

    its(:root) { should_not be_nil }
    its(:posts_directory) { should_not be_nil }
    its(:permalink) { should == '/posts/:slug' }
    its(:layouts_directory) { should_not be_nil }
  end

  describe '.posts_directory' do
    subject { Blargh.config.posts_directory }

    context 'default' do
      it { should be_an_instance_of(Pathname) }
      it { should == Pathname.new('posts') }
    end

    context 'when posts_directory is set' do
      before(:each) { Blargh.config.posts_directory = 'random_dir' }

      it { should be_an_instance_of(Pathname) }
      it { should == Pathname.new('random_dir') }
    end
  end

  describe '.layouts_directory' do
    subject { Blargh.config.layouts_directory }

    context 'default' do
      it { should be_an_instance_of(Pathname) }
      it { should == Pathname.new('layouts') }
    end

    context 'when layouts_directory is set' do
      before(:each) { Blargh.config.layouts_directory = 'random_dir' }

      it { should be_an_instance_of(Pathname) }
      it { should == Pathname.new('random_dir') }
    end
  end

  describe '.root' do
    before(:each) do
      Blargh.config.reset_root
      generate_source
      Dir.chdir(source_path)
    end

    subject { Blargh.config.root }

    after(:each) do
      Dir.chdir(working_directory)
      remove_source
    end

    context 'when the root is set' do
      before(:each) { Blargh.config.root = source_path }

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

        it { should be_an_instance_of(Pathname) }
        it { should == source_path }
      end
    end

    context 'default' do
      context 'when there is a config.ru' do
        it { should be_an_instance_of(Pathname) }
        it { should == source_path }
      end

      context 'when there is NO config.ru' do
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
