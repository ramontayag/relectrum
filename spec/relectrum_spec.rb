require "spec_helper"

describe Relectrum do

  describe "attributes" do
    %i[electrum_path sx_path].each_with_index do |attr, i|
      it "has the attribute #{attr}" do
        described_class.send("#{attr}=", i)
        expect(described_class.send(attr)).to eq i
      end
    end
  end

  describe ".configure" do
    it "yields itself for easy configuration" do
      Relectrum.configure do |c|
        c.electrum_path = "x"
      end
      expect(Relectrum.electrum_path).to eq "x"
    end
  end

  describe ".new" do
    let(:electrum_path) { "/path/to/electrum" }
    let(:sx_path) { "/path/to/sx" }
    let(:client) { double(Relectrum::Client) }

    before do
      allow(Relectrum::Client).to receive(:new).with(
        electrum_path: electrum_path,
        sx_path: sx_path,
      ).and_return(client)
    end

    context "paths are overriden" do
      subject(:relectrum) do
        described_class.new(
          electrum_path: electrum_path,
          sx_path: sx_path,
        )
      end

      it { is_expected.to eq client }
    end

    context "paths are default" do
      before do
        Relectrum.electrum_path = "electrum"
        Relectrum.sx_path = "sx"

        allow(Relectrum::Client).to receive(:new).with(
          electrum_path: "electrum",
          sx_path: "sx",
        ).and_return(client)
      end

      subject { described_class.new }

      it { is_expected.to eq client }
    end
  end

end
