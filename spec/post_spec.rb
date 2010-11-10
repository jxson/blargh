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
    # save a new record
    # save an existing record
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
    it "does something" do
      puts
    end

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
    before(:each) do
      @post = Blargh::Post.create(:body => 'Wild Stallions fan art...')
    end

    subject { @post }

    it { should be_a_kind_of(Blargh::Post) }
    it { should_not be_a_new_record }
  end

  describe '.create!' do
    # context "inserting with a field that is not unique" do
    #
    #   context "when a unique index exists" do
    #     before do
    #       Person.create_indexes
    #     end
    #
    #     after do
    #       Person.delete_all
    #     end
    #
    #     it "raises an error" do
    #       Person.create!(:ssn => "555-55-9999")
    #       lambda { Person.create!(:ssn => "555-55-9999") }.should raise_error
    #     end
    #   end
    # end
  end

  describe '#create_file' do
    # save should create file
    # record should have a file
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
      # @person.update_attributes(:ssn => "555-55-1235", :pets => false, :title => nil)
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
      # @person.update_attributes(:ssn => "555-55-1235", :pets => false, :title => nil)
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

  describe '#destroy' do
    # check its destroyed
    # destroy should return true
    # @person.destroy
    # lambda { Person.find(@person.id) }.should raise_error
  end

  describe '#delete' do
    # check its destroyed
    # destroy should return true
    # @person.destroy
    # lambda { Person.find(@person.id) }.should raise_error
  end

  describe '.delete_all' do
    # it "deletes all the documents" do
    #   Person.delete_all
    #   Person.count.should == 0
    # end
    #
    # it "returns the number of documents deleted" do
    #   Person.delete_all.should == 1
    # end
  end

  describe '.destroy_all' do
    #
    # before do
    #   @person.save
    # end
    #
    # it "destroys all the documents" do
    #   Person.destroy_all
    #   Person.count.should == 0
    # end
    #
    # it "returns the number of documents destroyed" do
    #   Person.destroy_all.should == 1
    # end
  end

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


