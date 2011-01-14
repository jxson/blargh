require 'spec_helper'

describe Blargh::Post do
  let(:post) { Blargh::Post.new(:body => 'Oh man, kittens.') }
  subject { post }

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

  describe '#body' do
    its(:body) { should == 'Oh man, kittens.' }
    it { should validate_presence_of(:body) }
  end

  describe '#title' do
    context 'without a title' do
      its(:title) { should == post.body }
    end

    context 'with a title' do
      let(:title) { 'Check this out' }
      before(:each) { subject.title = title }

      its(:title) { should_not == post.body }
      its(:title) { should == title }
    end
  end

  describe '#description' do
    context 'description is set' do
      before(:each) do
        subject.description = 'some where between a title and a body'
      end

      its(:description) { should == 'some where between a title and a body' }
    end

    context 'description is NOT set' do
      context 'body is under 255 chars' do
        before(:each) { subject.body = 'just short of 255 chars' }

        its(:description) { should == 'just short of 255 chars' }
      end

      context 'body is over 255 chars' do
        let(:body) { Sparky.lorem(:words, 100) }
        before(:each) { subject.body = body }

        its(:description) { should == body.truncate(255) }
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
    its(:slug) { should == 'oh-man-kittens' }
  end

  describe '#content' do
    subject do
      Blargh::Post.new({
        :title => 'Dogs',
        :body => "\nOh man, {{ title }}.\n"
      })
    end

    its(:content) { should == '<p>Oh man, Dogs.</p>' }
  end

  describe 'persistence' do
    before(:each) do
      generate_source
      Blargh.config.root = souce_path
    end

    after(:each) { remove_source }

    let(:post) { Blargh::Post.new(:body => 'some junk about some stuff') }
    subject { post }

    describe '#new' do
      it { should be_new_record }
      it { should_not be_persisted }
      its(:file) { should be_nil }
    end

    describe '#save' do
      # save a new record
      # save an existing record
      context 'when valid' do
        its(:save) { should be_true }

        context 'after save' do
          before(:each) { post.save }

          it { should_not be_new_record }
          it { should be_persisted }
          its(:file) { should_not be_nil }
        end
      end # context 'when valid'

      context 'when invalid' do
        let(:post) { Blargh::Post.new }
        subject { post }

        its(:save) { should be_false }

        context 'after save' do
          before(:each) { post.save }

          it { should_not be_persisted }
          its(:errors) { should include(:body=>["can't be blank"]) }
          its(:file) { should be_nil }
        end
      end # context 'when invalid'
    end #  describe '#save'

    describe 'save!' do
      context 'when valid' do
        its(:save!) { should be_true }
      end

      context 'when invalid' do
        before(:each) { post.body = nil }

        it "should raise an error" do
          expect { @post.save! }.to
            raise_error(Blargh::Post::ValidationError)
        end
      end
    end # describe 'save!'

    describe '.create' do
      let(:post) { Blargh::Post.create(:body => 'Blah, blah, blah') }
      subject { post }

      it { should be_a_kind_of(Blargh::Post) }
      it { should_not be_a_new_record }

      context 'when valid' do
        it { should be_valid }
        it { should be_persisted }
        its(:file) { should_not be_nil }
      end # context 'when valid'

      context 'when invalid' do
        let(:post) { Blargh::Post.create }
        subject { post }

        it { should_not be_valid }
        it { should_not be_persisted }
        its(:file) { should be_nil }
      end # context 'when invalid'
    end # describe '.create'

    describe '.create!' do
      context 'when valid' do
        subject { Blargh::Post.create!(:body => 'Blah, blah') }

        it { should be_a_kind_of(Blargh::Post) }
        it { should_not be_a_new_record }
        it { should be_valid }
        it { should be_persisted }
        its(:file) { should_not be_nil }
      end

      context 'when invalid' do
        it "it should raise an error" do
          expect {Blargh::Post.create! }.to
            raise_error(Blargh::Post::ValidationError)
        end
      end
    end # describe '.create!'

    describe '#delete' do
      before(:each) { post.save! }

      context 'new post' do
        it 'it should be destroyed' do
          expect { post.destroy }.to change(Blargh::Post, :count).by(-1)
        end

        it 'should be gone' do
          expect { post.destroy }.to
            change(post, :persisted?).from(true).to(false)
        end

        it "should raise an error when looking for the destroyed post" do
          post.destroy
          expect { Blargh::Post.find(post.id) }.to
            raise_error(Blargh::Post::RecordNotFound)
        end
      end # context 'new post'
    end # describe '#delete'
  end # describe 'persistence'

  describe '.where' do
    before(:each) do
      generate_source
      @pirates = Blargh::Post.create(:body => 'Blargh!')
      @zombies = Blargh::Post.create(:body => 'brains.')
      @cyborgs = Blargh::Post.create(:body => '1001001')
    end

    after(:each) { remove_source }

    context '(:slug => "something")' do
      subject { Blargh::Post.where(:slug => 'blargh') }

      it { should be_an_instance_of(Blargh::Query) }

      context '.first' do
        subject { Blargh::Post.where(:slug => 'blargh').first }
        it { should == @pirates }

        it 'should raise RecordNotFound when there is no record' do
          expect {
            Blargh::Post.where(:slug => 'unicorns').first
          }.should raise_error(Blargh::Post::RecordNotFound)
        end
      end

      context '.all' do
        subject { Blargh::Post.where(:slug => 'blargh').all }

        it { should include(@pirates) }
        it { should_not include(@zombies) }
      end
    end # context '(:slug => "something")'

    context '(:id => 1293004664)' do
      subject { Blargh::Post.where(:id => @pirates.id) }

      it { should be_an_instance_of(Blargh::Query) }

      context '.first' do
        subject { Blargh::Post.where(:id => @pirates.id).first }
        it { should == @pirates }
      end

      context '.all' do
        subject { Blargh::Post.where(:id => @pirates.id).all }

        it { should include(@pirates) }
        it { should_not include(@zombies) }
      end
    end # context ':id => 1293004664'
  end # describe '.where'

  describe '.find' do
    before(:each) do
      generate_source
      @pirates = Blargh::Post.create(:body => 'Blargh!')
      @zombies = Blargh::Post.create(:body => 'brains...')
    end

    after(:each) { remove_source }

    context 'with the slug condition' do
      subject { Blargh::Post.find(:slug => 'blargh') }

      it { should include(@pirates) }
      it { should_not include(@zombies) }
    end

    context 'with the id condition' do
      subject { Blargh::Post.find(:id => @pirates.id) }

      it { should include(@pirates) }
      it { should_not include(@zombies) }
    end
  end # describe '.find'
end
