require "spec_helper"

module Relectrum
  describe Transaction do

    it "is initialized with an id and electrum wrapper" do
      electrum = Wrapper.new(electrum_path: "electrum")
      tx = described_class.new(hash: "txid", electrum: electrum)
      expect(tx.id).to eq "txid"
      expect(tx.electrum).to eq electrum
    end

    describe "#hex" do
      let(:electrum) { Wrapper.new(electrum_path: "electrum") }
      let(:raw_transaction) { { complete: true, hex: "some_long_hex" } }
      let(:transaction) { Transaction.new(hash: "txid", electrum: electrum) }
      subject(:hex) { transaction.hex }

      before do
        allow(electrum).to receive(:get_raw_transaction).with("txid").
          and_return(raw_transaction)
      end

      it "fetches the hex of the transaction" do
        expect(hex).to eq "some_long_hex"
      end
    end

    describe "#type" do
      let(:address) { "address1920831209" }
      let(:electrum) { Wrapper.new(electrum_path: "electrum") }
      let(:transaction) do
        Transaction.new(hash: "txid", address: address, electrum: electrum)
      end
      let(:decoded_transaction) { {decoded: "tx", info: "lala"} }
      subject(:type) { transaction.type }

      before do
        allow(transaction).to receive(:hex).and_return("hex")
        allow(electrum).to receive(:decode_raw_transaction).
          with("hex").
          and_return(decoded_transaction)
        allow(DetermineTransactionType).to receive(:execute).
          with(address, decoded_transaction).
          and_return("txtype")
      end

      it { is_expected.to eq "txtype" }
    end

    describe "#amount" do
      let(:address) { "address1920831209" }
      let(:electrum) { Wrapper.new(electrum_path: "electrum") }
      let(:transaction) do
        Transaction.new(hash: "txid", address: address, electrum: electrum)
      end
      let(:decoded_transaction) { {decoded: "tx", info: "lala"} }
      subject(:type) { transaction.amount }

      before do
        allow(transaction).to receive(:hex).and_return("hex")
        allow(electrum).to receive(:decode_raw_transaction).
          with("hex").
          and_return(decoded_transaction)
        allow(DetermineTransactionAmount).to receive(:execute).
          with(address, decoded_transaction).
          and_return(900000)
      end

      it { is_expected.to eq 900000 }
    end

    describe "#confirmations" do
      context "transaction height is 0 (no height yet)" do
        it "is the block_height less the transaction height" do
          tx = described_class.new(height: 0, block_height: 10)
          expect(tx.confirmations).to eq 0
        end
      end

      context "transaction height is not zero" do
        it "is the block_height less the transaction height" do
          tx = described_class.new(height: 9, block_height: 10)
          expect(tx.confirmations).to eq 2
        end
      end
    end

  end
end
