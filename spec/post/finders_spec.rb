require 'spec_helper'

describe Blargh::Post do
  before(:each) do
    Blargh.configure do |config|
      config.root = File.expand_path('../../../', __FILE__)
      config.posts_directory = 'posts'
    end

    @post = Blargh::Post.create!(:body => 'Kittens, so cute <3')
  end

  # after(:each) { Blargh::Post.delete_all }

  subject { @post }

  describe '.find' do
    context 'with an id' do
      it "should find a document" do
        Blargh::Post.find(@post.id).should be_a_kind_of(Blargh::Post)
      end

      context 'no record' do
        it "should raise a not found error" do
          pending
        end
      end

      context 'with nil as an id' do
        it "should raise an invalid argument error" do

        end
      end
    end

    context 'by slug' do

    end
  end

  describe '.all' do

  end

  describe '.count' do

  end

  describe '.first' do

  end

  describe '.last' do

  end

  describe '.paginate' do

  end
end