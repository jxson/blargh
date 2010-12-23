require 'spec_helper'

describe Blargh::Post do
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
