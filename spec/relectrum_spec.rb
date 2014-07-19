require "spec_helper"

describe Relectrum do

  describe "#electrum" do
    let(:path) { "/path/to/electrum" }
    subject(:relectrum) { described_class.new(path) }
    let(:wrapper) { Relectrum::Wrapper.new(path) }

    before do
      allow(Relectrum::Wrapper).to receive(:new).with(path).and_return(wrapper)
    end

    it { is_expected.to eq wrapper }
  end

end
