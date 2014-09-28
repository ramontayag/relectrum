require "spec_helper"

module Relectrum
  module Address
    describe InitializeTransactions, ".execute" do
      let(:electrum) { double(Wrapper) }
      let(:address_history) do
        [
          {
            height: 9,
            tx_hash: "9d"
          },
          {
            height: 10,
            tx_hash: "10d"
          }
        ]
      end
      let(:block_height) { 20 }
      let(:address) { "address1920831209"}
      let(:transaction_1) { double(Transaction) }
      let(:transaction_2) { double(Transaction) }

      let(:resulting_ctx) do
        described_class.execute(
          address: address,
          address_history: address_history,
          electrum: electrum,
          block_height: block_height,
        )
      end

      subject(:transactions) { resulting_ctx.transactions }

      before do
        allow(Transaction).to receive(:new).with(
          address: address,
          electrum: electrum,
          hash: "9d",
          height: 9,
          block_height: block_height,
        ).and_return(transaction_1)
        allow(Transaction).to receive(:new).with(
          address: address,
          electrum: electrum,
          hash: "10d",
          height: 10,
          block_height: block_height,
        ).and_return(transaction_2)
      end

      it "initializes a transaction for each in the :address_history" do
        expect(transactions.size).to eq 2
        expect(transactions.first).to eq transaction_1
        expect(transactions.last).to eq transaction_2
      end

    end
  end
end
