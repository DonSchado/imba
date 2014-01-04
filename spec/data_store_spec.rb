require 'spec_helper'

describe Imba::DataStore do
  before(:all) do
    FileUtils.mkdir_p("#{Dir.pwd}/tmp/.imba_test")
    Imba::DataStore.path = "#{Dir.pwd}/tmp/.imba_test/test_data.pstore"
    Imba::DataStore.init
  end

  before(:each) { Imba::DataStore.clear }
  after(:all) { Imba::DataStore.clear }

  describe '#inspect' do
    subject { Imba::DataStore.inspect }
    it { expect(subject).to include('<Imba::DataStore: ') }
    it { expect(subject).to include(Imba::DataStore.path) }
    it { expect(subject).to include('imba/tmp/.imba_test/test_data.pstore') }
    it { expect(subject).to include('@data=#<PStore:') }
    it { expect(subject).to include('@ultra_safe=true') }
    it { expect(subject).to include('@thread_safe=true') }
    it { expect(subject).to include('@table={}') }
  end

  describe 'read/write something in/from the data store' do
    before { Imba::DataStore[:something] = { foo: 'bar' } }
    it { expect(Imba::DataStore[:something]).to eql(foo: 'bar') }
    it { expect(Imba::DataStore.all).to eql([:something]) }
    it { expect(Imba::DataStore.key?(:something)).to be_true }
  end

  describe 'delete something from the data store' do
    before do
      Imba::DataStore[:stay_my_friend] = { foo: 'bar' }
      Imba::DataStore[:delete_me] = 'can\'t wait'
      Imba::DataStore.delete(:delete_me)
    end
    it { expect(Imba::DataStore.key?(:delete_me)).to be_false }
    it { expect(Imba::DataStore.all).to eql([:stay_my_friend]) }
  end

  describe 'multi transactions' do
    before do
      Imba::DataStore.transaction do |data|
        data[:number] = 42
        data[:foo] = 'bar bazly'
        data[:words] = %w[amazing stuff inside transaction]
      end
    end

    it { expect(Imba::DataStore.all).to eql([:number, :foo, :words]) }
    it { expect(Imba::DataStore[:words]).to eql(%w[amazing stuff inside transaction]) }
  end

end
