require 'spec_helper'

describe Blargh::Post do
  before(:each) do
    @attributes = {
      :body => 'Oh man, kittens.'
    }

    @post = Blargh::Post.new(@attributes)
  end

  subject { @post }

  its(:body) { should == @attributes[:body] }
  it { should validate_presence_of(:body) }

  context 'without a title' do
    its(:title) { should == @attributes[:body] }
  end

  context 'with a title' do
    before(:each) { subject.title = 'Check this out' }

    its(:title) { should_not == @attributes[:body] }
    its(:title) { should == 'Check this out'}
  end







  # it { should respond_to(:description) }
  # it { should respond_to(:slug) } # url safe
  # it { should respond_to(:basename) } # git only
  # it { should respond_to(:published_at) }
  # it { should respond_to(:draft) }
  # it { should respond_to(:published) }
  # it { should respond_to(:new_record) }
  #
  # describe '#description' do
  #   context 'description was NOT set' do
  #     context 'body length is less than 255 characters' do
  #     end
  #
  #     context 'body length is more than 255 characters' do
  #     end
  #   end
  #
  #   context 'description was set' do
  #     # desc is whatever was set
  #   end
  #
  # end
  #
  # describe '#slug' do
  #   # url safe version of the title, set befroe saving but after initialization
  #   # allow user to override
  # end
  #
  # describe '#save' do
  #   # saves to file based on config
  # end
  #
  # describe '#tags' do
  #   # it { should respond_to(:tags) }
  # end
  #
  # # ============================================================================
  # # = Class methods
  # # ============================================================================
  # describe '.new' do
  #   subject do
  #     Blargh::Post.new({
  #       :title => 'Some random blog post',
  #       :body => 'Some random text for the body of the post'
  #     })
  #   end
  #
  #   it { should be_draft }
  #   it { should_not be_published }
  #   its(:title) { should == 'Some random blog post' }
  #   its(:body) { should == 'Some random text for the body of the post' }
  # end
  #
  # describe '.find' do
  #
  # end
  #
  # describe '.find_by_slug' do
  #
  # end

  describe 'ActiveModel Lint tests' do
    require 'test/unit/assertions'
    require 'active_model/lint'

    include Test::Unit::Assertions
    include ActiveModel::Lint::Tests

    ActiveModel::Lint::Tests.public_instance_methods.map{ |m| m.to_s }.grep(/^test/).each do |m|
      example m.gsub('_',' ') do
        send m
      end
    end

    def model
      Blargh::Post.new
    end
  end # describe 'ActiveModel Lint tests'
end


