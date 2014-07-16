require "spec_helper"

describe Relectrum do

  describe "#electrum" do
    let(:path) { "/path/to/electrum" }
    subject(:relectrum) { described_class.new(path) }
    let(:client) { Relectrum::Client.new(path) }

    before do
      allow(Relectrum::Client).to receive(:new).with(path).and_return(client)
    end

    it { is_expected.to eq client }
  end

end
