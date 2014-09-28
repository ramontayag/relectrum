require "spec_helper"

module Relectrum
  module Address
    describe GetTransactions, ".execute" do

      let(:electrum) { double(Wrapper) }
      let(:address_history) { %w(tx1 tx2) }
      subject(:resulting_ctx) do
        described_class.execute(electrum: electrum, address: "myaddr")
      end

      before do
        allow(electrum).to receive(:get_address_history).with("myaddr").
          and_return(address_history)
      end

      it "fetches the address history" do
        expect(resulting_ctx.address_history).to eq address_history
      end

    end
  end
end
