require 'spec_helper'

describe Blargh::Post do
  before(:each) do
    @attributes = {
      :body => 'Oh man, kittens.'
    }

    @post = Blargh::Post.new(@attributes)
  end

  subject { @post }

  # ==========================================================================
  # = Attributes
  # ==========================================================================
  its(:body) { should == @attributes[:body] }
  it { should validate_presence_of(:body) }

  describe '#title' do
    context 'without a title' do
      its(:title) { should == @attributes[:body] }
    end

    context 'with a title' do
      before(:each) do
        @title = 'Check this out'
        subject.title = @title
      end

      its(:title) { should_not == @attributes[:body] }
      its(:title) { should == @title }
    end
  end

  describe '#description' do
    context 'description is set' do
      before(:each) do
        @description = 'some where between a title and a body'
        subject.description = @description
      end

      its(:description) { should == @description }
    end

    context 'description is NOT set' do
      before(:each) { subject.description = nil }

      context 'body is under 255 chars' do
        before(:each) do
          @body = 'just short of 255 chars'
          subject.body = @body
        end

        its(:description) { should == @body }
      end

      context 'body is over 255 chars' do
        before(:each) do
          @body = Sparky.lorem(:words, 100)
          subject.body = @body
        end

        its(:description) { should == @body.truncate(255) }
      end
    end
  end

  describe '#publish' do
    it { should be_published }
    it { should_not be_draft }

    context 'setting publish to false' do
      before(:each) { subject.publish = false }

      it { should_not be_published }
      it { should be_draft }
    end
  end

  describe '#slug' do
    its(:slug) { should == 'oh-man-kittens'}
  end

  # ==========================================================================
  # = persistence
  # ==========================================================================
  it { should be_new_record }
  it { should_not be_persisted }

  describe '#save' do
    context 'when valid' do
      before(:each) do
        Blargh.configure do |config|
          config.root = File.expand_path('../../', __FILE__)
          config.posts_directory = 'posts'
        end
      end

      its(:save) { should be_true }

      context 'after save' do
        before(:each) { subject.save }

        its(:persisted?) { should be_true }
        its(:new_record?) { should be_false }
        it { should have_file }
      end
    end

    context 'when invalid' do
      before(:each) { @post = Blargh::Post.new; @post.save }
      subject { @post }

      its(:save) { should be_false }
      its(:errors) { should include(:body=>["can't be blank"]) }
    end
  end

  # it { should respond_to(:basename) } # git only

  # describe '.find' do
  #
  # end
  #
  # describe '.find_by_slug' do
  #
  # end

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


