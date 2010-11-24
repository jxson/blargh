require 'spec_helper'

describe Blargh::Post do
  before(:each) do
    generate_source
    Blargh.config.root = souce_path
  end

  after(:each) { remove_source }

  subject { Blargh::Post }

  describe '.find' do
    # context 'with an id' do
    #   it "should find a document" do
    #     Blargh::Post.find(@post.id).should be_a_kind_of(Blargh::Post)
    #   end
    #
    #   context 'no record' do
    #     before(:each) { @post.destroy }
    #
    #     it "should raise a not found error" do
    #       doing { Blargh::Post.find(@post.id) }
    #         .should raise_error(Blargh::Post::NotFound)
    #     end
    #   end
    #
    #   context 'with nil as an id' do
    #     it "should raise an invalid argument error" do
    #       doing { Blargh::Post.find(nil) }
    #         .should raise_error(Blargh::Post::InvalidArgument)
    #     end
    #   end
    # end

    context 'by slug' do
      context 'a post exists' do
        it "should find a document" do
          Blargh::Post.find_by_slug('first-post')
            .should be_a_kind_of(Blargh::Post)
        end
      end

      # context 'no post found' do
      #   before(:each) { @post.destroy }
      #
      #   it "should raise a not found error" do
      #     doing { Blargh::Post.find_by_slug(@post.slug) }
      #       .should raise_error(Blargh::Post::NotFound)
      #   end
      # end
      #
      # context 'with nil as a slug' do
      #   it "should raise an invalid argument error" do
      #     doing { Blargh::Post.find_by_slug(nil) }
      #       .should raise_error(Blargh::Post::InvalidArgument)
      #   end
      # end
    end
  end
end