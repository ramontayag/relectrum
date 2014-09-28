require "spec_helper"

module Relectrum
  describe GetAddressTransactions, ".execute" do

    let(:actions) do
      [
        Address::GetTransactions,
        Address::InitializeTransactions,
      ]
    end

    let(:electrum) { Wrapper.new(electrum_path: CONFIG.fetch(:electrum_path)) }

    let(:ctx) do
      {
        electrum: electrum,
        address: "my_addr",
        block_height: 10000,
      }
    end

    it "executes the actions in order" do
      actions.each do |action|
        expect(action).to receive(:execute).with(ctx).and_return(ctx)
      end

      described_class.execute(
        electrum: electrum,
        address: "my_addr",
        block_height: 10000,
      )
    end

    it "parses transactions and returns ruby object for better consumption", integration: true do
      result = described_class.execute(
        electrum: electrum,
        address: "1Bmrh28LowzY7L3bnaX7aRVRBjo5Gw2Vuj",
        # block_height: 100000,
      )

      transactions = result.fetch(:transactions)

      transactions.each do |transaction|
        expect(transaction).to be_a Transaction
        expect(transaction.id).to be_a String
        expect(%w(receive send).include?(transaction.type)).to eq true
      end
    end

  end
end
