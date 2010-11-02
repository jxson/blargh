require 'spec_helper'

describe Blargh::Post do
  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should respond_to(:description) }
  it { should respond_to(:slug) } # url safe
  it { should respond_to(:basename) } # git only
  it { should respond_to(:published_at) }
  it { should respond_to(:draft) }
  it { should respond_to(:published) }
  it { should respond_to(:new_record) }
  
  describe '#save' do
    
  end
  
  describe '#tags' do
    # it { should respond_to(:tags) }
  end
  
  # ============================================================================
  # = Class methods
  # ============================================================================
  describe '.new' do
    subject do
      Blargh::Post.new({
        :title => 'Some random blog post',
        :body => 'Some random text for the body of the post'
      })
    end
    
    its(:title) { should == 'Some random blog post' }
    its(:body) { should == 'Some random text for the body of the post' }
  end
  
  describe '.find' do
    
  end
  
  describe '.find_by_slug' do
    
  end
end


