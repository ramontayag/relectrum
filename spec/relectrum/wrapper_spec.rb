require "spec_helper"

module Relectrum
  describe Wrapper do

    describe "#electrum" do
      let(:path) { "/path/to/electrum" }
      subject { described_class.new(path).electrum }
      it { is_expected.to eq path }
    end

    describe "#get_version", integration: true do
      subject { described_class.new(CONFIG.fetch(:electrum_path)).get_version }
      it { is_expected.to be_a String }
    end

    describe "#get_address_balance" do
      let(:path) { "/path/to/electrum" }
      let(:address) { "127wjEjVE442HX89fkDR7Tc1PA92zsSdyA" }
      let(:command) { "getaddressbalance #{address}" }
      let(:wrapper) { described_class.new(path) }
      let(:json_response) do
        "{\n    \"confirmed\": \"1.2\", \n    \"unconfirmed\": \"3.0\"\n}\n"
      end
      subject(:balance) { wrapper.get_address_balance(address) }

      before do
        allow(Executor).to receive(:execute).with(path, command).
          and_return(json_response)
      end

      it "returns the confirmed and unconfirmed balance" do
        expect(balance[:confirmed]).to eq "1.2"
        expect(balance[:unconfirmed]).to eq "3.0"
      end
    end

    describe "#validate_address" do
      let(:path) { "/path/to/electrum" }
      let(:address) { "127wjEjVE442HX89fkDR7Tc1PA92zsSdyA" }
      let(:command) { "validateaddress #{address}" }
      let(:wrapper) { described_class.new(path) }
      subject(:balance) { wrapper.validate_address(address) }

      before do
        allow(Executor).to receive(:execute).with(path, command).
          and_return(json_response)
      end

      context "address is valid" do
        let(:json_response) do
          "{\n    \"address\": \"127wjEjVE442HX89fkDR7Tc1PA92zsSdyA\", \n    \"isvalid\": true\n}\n"
        end
        it { is_expected.to eq true }
      end

      context "address is invalid" do
        let(:json_response) do
          "{\n    \"address\": \"127wjEjVE442HX89fkDR7Tc1PA92zsSdyA\", \n    \"isvalid\": false\n}\n"
        end
        it { is_expected.to eq false }
      end
    end

    describe "#auto_cycle" do
      let(:path) { "/path/to/electrum" }
      let(:command) { "getconfig auto_cycle" }
      let(:response) { "True" }
      let(:wrapper) { described_class.new(path) }

      before do
        allow(Executor).to receive(:execute).with(path, command).
          and_return(response)
      end

      it "returns the auto_cycle config value" do
        expect(wrapper.auto_cycle).to eq true
      end
    end

    describe "#auto_cycle=" do
      let(:path) { "/path/to/electrum" }
      let(:wrapper) { described_class.new(path) }

      context "setting to true" do
        it "sets the auto_cycle config" do
          expect(Executor).to receive(:execute).
            with(path, "setconfig auto_cycle True")
          wrapper.auto_cycle = true
        end
      end

      context "setting to false" do
        it "sets the auto_cycle config" do
          expect(Executor).to receive(:execute).
            with(path, "setconfig auto_cycle False")
          wrapper.auto_cycle = false
        end
      end
    end

    describe "#get_address_history" do
      let(:path) { "/electrum" }
      let(:wrapper) { described_class.new(path) }
      let(:json_response) do
        <<-EOS
          [
            {
                "height": 276,
                "tx_hash": "tx_1_3907"
            },
            {
                "height": 278,
                "tx_hash": "tx_2_0321"
            }
          ]
        EOS
      end
      let(:history) { wrapper.get_address_history("myaddress") }

      before do
        allow(Executor).to receive(:execute).
          with(path, "getaddresshistory myaddress").
          and_return(json_response)
      end

      it "returns the address history" do
        expect(history).to be_an Array
        expect(history[0][:height]).to eq 276
        expect(history[0][:tx_hash]).to eq "tx_1_3907"
        expect(history[1][:height]).to eq 278
        expect(history[1][:tx_hash]).to eq "tx_2_0321"
      end
    end

    describe "#get_raw_transaction" do
      let(:path) { "/electrum" }
      let(:wrapper) { described_class.new(path) }
      let(:json_response) do
        <<-EOS
          {
            "complete": true,
            "hex": "some_long_hex"
          }
        EOS
      end
      let(:tx_details) { wrapper.get_raw_transaction("mytxhash") }

      before do
        allow(Executor).to receive(:execute).
          with(path, "getrawtransaction mytxhash").
          and_return(json_response)
      end

      it "returns the address tx_details" do
        expect(tx_details).to be_a Hash
        expect(tx_details[:complete]).to eq true
        expect(tx_details[:hex]).to eq "some_long_hex"
      end
    end

    describe "#decode_raw_transaction" do
      let(:path) { "/electrum" }
      let(:wrapper) { described_class.new(path) }
      let(:json_response) do
        <<-EOS
        {
          "inputs": [
            {
              "address": "inputaddr1",
              "prevout_hash": "prevout_hash_1",
              "prevout_n": 0,
              "sequence": 5,
              "signatures": null
            },
            {
              "address": "inputaddr2",
              "prevout_hash": "prevout_hash_2",
              "prevout_n": 1,
              "sequence": 6,
              "signatures": null
            }
          ],
          "lockTime": 0,
          "outputs":
            [
              {
                "address": "outputaddr1",
                "is_pubkey": false,
                "prevout_n": 0,
                "scriptPubKey": "scriptPubKey1",
                "value": 10
              }
            ],
            "version": 1
          }
        EOS
      end
      let(:tx_details) { wrapper.decode_raw_transaction("txhex") }

      before do
        allow(Executor).to receive(:execute).
          with(path, "decoderawtransaction txhex").
          and_return(json_response)
      end

      it "returns the tx details" do
        expect(tx_details).to be_a Hash
        inputs = tx_details.fetch(:inputs)
        expect(inputs).to be_an Array
        expect(inputs.size).to eq 2
        expect(inputs[0][:address]).to eq "inputaddr1"
        expect(inputs[0][:prevout_hash]).to eq "prevout_hash_1"
        expect(inputs[0][:prevout_n]).to eq 0
        expect(inputs[0][:sequence]).to eq 5
        expect(inputs[0][:signatures]).to eq nil

        expect(inputs[1][:address]).to eq "inputaddr2"
        expect(inputs[1][:prevout_hash]).to eq "prevout_hash_2"
        expect(inputs[1][:prevout_n]).to eq 1
        expect(inputs[1][:sequence]).to eq 6
        expect(inputs[1][:signatures]).to eq nil

        lock_time = tx_details.fetch(:lockTime)
        expect(lock_time).to eq 0

        outputs = tx_details.fetch(:outputs)
        expect(outputs).to be_an Array
        expect(outputs.size).to eq 1
        expect(outputs[0][:address]).to eq "outputaddr1"
        expect(outputs[0][:is_pubkey]).to eq false
        expect(outputs[0][:prevout_n]).to eq 0
        expect(outputs[0][:scriptPubKey]).to eq "scriptPubKey1"
        expect(outputs[0][:value]).to eq 10
      end
    end

  end
end
