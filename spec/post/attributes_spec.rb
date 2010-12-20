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

  describe '#content' do
    before(:each) do
      @attributes = {
        :title => 'Dogs',
        :body => "\nOh man, {{ title }}.\n"
      }

      @post = Blargh::Post.new(@attributes)
    end

    its(:content) { should == '<p>Oh man, Dogs.</p>' }
  end
end