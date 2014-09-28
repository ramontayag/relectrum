require "spec_helper"

module Relectrum
  describe DetermineTransactionType, ".execute" do

    subject { described_class.execute(address, decoded_transaction) }

    context "transaction input is my address" do
      let(:address) { "myaddress" }
      let(:decoded_transaction) do
        {
          inputs: [
            {
              address: "myaddress",
              prevout_hash: "prevout_hash_1",
              prevout_n: 0,
              sequence: 1,
              signatures: nil
            }
          ],
          lockTime: 0,
          outputs: [
            {
              address: "someotheraddress",
              is_pubkey: false,
              prevout_n: 0,
              scriptPubKey: "scriptPubKey1",
              value: 4
            },
            {
              address: "mychangeaddress",
              is_pubkey: false,
              prevout_n: 0,
              scriptPubKey: "scriptPubKey1",
              value: 3
            },
          ],
          version: 1
        }
      end

      it { is_expected.to eq "send" }
    end

    context "transaction input address is not my address" do
      let(:address) { "myaddress" }
      let(:decoded_transaction) do
        {
          inputs: [
            {
              address: "inputaddr1",
              prevout_hash: "prevout_hash_1",
              prevout_n: 0,
              sequence: 5,
              signatures: nil
            },
            {
              address: "inputaddr2",
              prevout_hash: "prevout_hash_2",
              prevout_n: 1,
              sequence: 6,
              signatures: nil
            }
          ],
          lockTime: 0,
          outputs:
          [
            {
              address: "myaddress",
              is_pubkey: false,
              prevout_n: 0,
              scriptPubKey: "scriptPubKey1",
              value: 10
            },
            {
              address: "theirchangeaddress",
              is_pubkey: false,
              prevout_n: 0,
              scriptPubKey: "scriptPubKey1",
              value: 6
            },
          ],
          version: 1
        }
      end

      it { is_expected.to eq "receive" }
    end

  end
end
