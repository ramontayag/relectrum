require "spec_helper"

module Relectrum
  describe DetermineTransactionAmount, ".execute" do

    context "transaction is a receive" do
      subject(:amount) { described_class.execute(address, decoded_transaction) }
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
          outputs: [
            [
              "address",
              "someoneelsesmaybetheirchangeaddress",
              8
            ],
            [
              "address",
              "myaddress",
              10
            ],
          ],
          version: 1
        }
      end

      it { is_expected.to eq 10 }
    end

    context "transaction is a send" do
      subject(:amount) { described_class.execute(address, decoded_transaction) }
      let(:address) { "myaddress" }
      let(:decoded_transaction) do
        {
          inputs: [
            {
              address: "myaddress",
              prevout_hash: "prevout_hash_1",
              prevout_n: 0,
              sequence: 5,
              signatures: nil
            },
          ],
          lockTime: 0,
          outputs: [
            [
              "address",
              "someotheraddress",
              2
            ],
            [
              "address",
              "mychangeaddress",
              10
            ]
          ],
          version: 1
        }
      end

      it { is_expected.to eq 12 }
    end

  end
end
