require 'warmup.rb'

describe Warmup do

  describe 'warmups' do
    let(:warmup){Warmup.new}

    it 'tests gets_shout' do
      warmup.stub!(:gets).and_return("test")
      expect(warmup.gets_shout).to eq("TEST")
    end

    it 'tests triple_size' do
      fake_array = double("item", :size => 1)

      expect(warmup.triple_size(fake_array)).to eq(3)
    end

    describe 'calls_some_methods' do
      let(:warmup){Warmup.new}
      let(:word){"testing"}

      it 'tests string upcased' do
        allow(word).to receive(:upcase!).and_return("TESTING")
        word.should_receive(:upcase!)
        expect(warmup.calls_some_methods(word)).to eq("I am unrelated")
      end

      it 'tests string reversed' do
        word.should_receive(:reverse!)
        expect(warmup.calls_some_methods(word)).to eq("I am unrelated")
      end

      it 'tests diff object' do
        expect(warmup.calls_some_methods(word).object_id).not_to eq(word.object_id)
      end
    end
  end

end
