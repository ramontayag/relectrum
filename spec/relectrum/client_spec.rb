require "spec_helper"

module Relectrum
  describe Client do

    describe "initialization" do
      context "no configuration is given" do
        it "defaults to the global configuration" do
          Relectrum.configure do |c|
            c.electrum_path = "/path/elec"
            c.sx_path = "/sx/path"
          end

          client = described_class.new

          expect(client.electrum_path).to eq "/path/elec"
          expect(client.sx_path).to eq "/sx/path"
        end
      end

      context "configuration is given" do
        it "uses the given configuration" do
          client = described_class.new(
            electrum_path: "/path/elec",
            sx_path: "/sx/path"
          )

          expect(client.electrum_path).to eq "/path/elec"
          expect(client.sx_path).to eq "/sx/path"
        end
      end
    end

    describe "#address_transactions" do
      let(:client) do
        described_class.new(electrum_path: "electrum")
      end
      let(:electrum) { double(Wrapper) }
      let(:resulting_ctx) do
        double(LightService::Context, transactions: %w(tx1 tx2))
      end

      before do
        allow(client).to receive(:last_block_height).and_return(2212)
        allow(Wrapper).to receive(:new).with(electrum_path: "electrum").
          and_return(electrum)
        allow(GetAddressTransactions).to receive(:execute).
          with(electrum: electrum, address: "myaddr", block_height: 2212).
          and_return(resulting_ctx)
      end

      it "returns the :transactions from GetAddressTransactions" do
        expect(client.address_transactions("myaddr")).to eq %w(tx1 tx2)
      end
    end

    describe "#last_block_height" do
      it "fetches the block height using sx" do
        rbsx = double(Rbsx::Client)
        allow(Rbsx).to receive(:new).with(sx_path: "/sx/path").and_return(rbsx)
        wrapper = described_class.new(sx_path: "/sx/path")
        allow(rbsx).to receive(:bci_fetch_last_height).and_return(218)
        expect(wrapper.last_block_height).to eq 218
      end
    end

  end
end
