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
