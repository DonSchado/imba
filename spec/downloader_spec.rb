require 'spec_helper'

module Imba
  describe Downloader do
    let(:fancy_queue) { Queue.new }
    let(:prepared) { subject.prepare(fancy_queue) }
    it { expect(prepared.download_queue).to eql(fancy_queue) }
    it { expect(prepared.items).to eql([]) }

    describe '#download' do
      let(:result) { double(title: 'Bar') }
      before do
        fancy_queue.push('Foo')
        expect(Imba::Movie).to receive(:search).with('Foo').and_return(result)
      end
      it { expect(prepared.download).to match_array([Imba::Downloader::Diff.new('Foo', 'Bar', result)]) }
    end
  end
end
