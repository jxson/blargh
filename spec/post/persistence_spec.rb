require 'spec_helper'

describe Blargh::Post do
  before(:each) do
    Blargh.configure do |config|
      config.root = File.expand_path('../../../', __FILE__)
      config.posts_directory = 'posts'
    end

    @post = Blargh::Post.new(:body => 'some junk about some stuff')
  end

  # after(:each) { Blargh::Post.delete_all }

  subject { @post }

  describe '#new' do
    it { should be_new_record }
    it { should_not be_persisted }
    it { should_not have_file }
  end

  describe '#save' do
    # save a new record
    # save an existing record
    context 'when valid' do
      before(:each) { @post.save }
      subject { @post }

      its(:save) { should be_true }

      context 'after save' do
        before(:each) { subject.save }

        its(:persisted?) { should be_true }
        its(:new_record?) { should be_false }
        it { should have_file }
      end
    end

    context 'when invalid' do
      before(:each) do
        @post = Blargh::Post.new
        @post.save
      end

      subject { @post }

      its(:save) { should be_false }
      its(:errors) { should include(:body=>["can't be blank"]) }
      it { should_not have_file }
    end
  end

  describe 'save!' do
    context 'when valid' do
      its(:save!) { should be_true }
    end

    context 'when invalid' do
      before(:each) { @post.body = nil }

      it "should raise an error" do
        doing { @post.save! }.should raise_error(Blargh::Post::ValidationError)
      end
    end
  end

  describe '.create' do
    before(:each) { @post = Blargh::Post.create(:body => 'Blah, blah, blah') }
    subject { @post }

    it { should be_a_kind_of(Blargh::Post) }
    it { should_not be_a_new_record }

    context 'when valid' do
      it { should be_valid }
      it { should have_file }
      it { should be_persisted }
    end

    context 'when invalid' do
      before(:each) { @post = Blargh::Post.create }
      subject { @post }

      it { should_not be_valid }
      it { should_not be_persisted }
      it { should_not have_file }
    end
  end

  describe '.create!' do
    context 'when valid' do
      before(:each) { @post = Blargh::Post.create!(:body => 'Blah, blah') }
      subject { @post }

      it { should be_a_kind_of(Blargh::Post) }
      it { should_not be_a_new_record }
      it { should be_valid }
      it { should have_file }
      it { should be_persisted }
    end

    context 'when invalid' do
      it "it should raise an error" do
        doing {Blargh::Post.create! }
          .should raise_error(Blargh::Post::ValidationError)
      end
    end
  end

  describe '#create_file' do
    it "its(:create_file) { should be_true }" do
      subject.create_file.should be_true
    end

    describe 'after #create_file' do
      before(:each) { @post.create_file }
      it { should be_persisted }
      it { should have_file }
    end
  end

  describe '#update_file' do
    context 'changed attributes' do
      # 1. save, 2 change an attr, 3. update 4. look up record
      # chack the it retained changes
    end

    context 'unchanged attributes' do
      # check that it returns true
    end
  end

  describe '#update_attributes' do
    context 'when valid' do
      # update_attributes should be true
      # it shoudl actaully update the record
      # @person.update_attributes(:ssn => "555-55-1235", :pets => false,
      # :title => nil)
      # @from_db = Person.find(@person.id)
      # @from_db.ssn.should == "555-55-1235"
      # @from_db.pets.should == false
      # @from_db.title.should be_nil
    end

    context 'when invalid' do
      # its(:update_attributes) { should be_false }
      # its(:errors) { should include(:body=>["can't be blank"]) }
      # it { should_not have_file }
    end
  end

  describe '#update_attributes!' do
    context 'when valid' do
      # update_attributes should be true
      # it shoudl actaully update the record
      # @person.update_attributes(:ssn => "555-55-1235", :pets => false,
      # :title => nil)
      # @from_db = Person.find(@person.id)
      # @from_db.ssn.should == "555-55-1235"
      # @from_db.pets.should == false
      # @from_db.title.should be_nil
    end

    context 'when invalid' do
      # its(:update_attributes) { should be_false }
      # its(:errors) { should include(:body=>["can't be blank"]) }
      # it { should_not have_file }
    end
  end

  describe '#delete' do
    before(:each) { @post.save! }

    context 'new post' do
      its(:destroy) { should be_true }

      context 'after destroy' do
        its(:destroy) { should be_true }

        it { should_not be_persisted }

        it "should raise an error when looking for the destroyed post" do
          lambda { Blargh::Post.find(@post.id) }
            .should raise_error(Blargh::Post::NotFound)
        end
      end
    end

    context 'found post' do
      before(:each) { @post_too = Blargh::Post.find(@post.id) }

      subject { @post_too }

      its(:destroy) { should be_true }

      context 'after destroy' do
        before(:each) { @post_too.destroy }

        its(:destroy) { should be_true }
        it { should_not be_persisted }

        it "should raise an error" do
          lambda { Blargh::Post.find(@post_too.id) }
            .should raise_error(Blargh::Post::NotFound)
        end
      end
    end
  end

  describe '.delete_all' do
    before(:each) { 3.times { Blargh::Post.create!(:body => 'junk') } }

    it "should zap everything like Mars Attacks! style" do
      Blargh::Post.delete_all.should == 3
      Blargh::Post.count.should == 0
    end
  end

  describe '.destroy_all' do
    before(:each) { 3.times { Blargh::Post.create!(:body => 'junk') } }

    it "should zap everything like Mars Attacks! style" do
      Blargh::Post.destroy_all.should == 3
      Blargh::Post.count.should == 0
    end
  end
end
