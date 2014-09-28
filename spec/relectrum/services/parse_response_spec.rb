require "spec_helper"

module Relectrum
  describe ParseResponse, ".execute" do

    context "given a response that is json only" do
      it "parses json" do
        response = <<-EOS.dedent
          [
              {
                  "height": 311470,
                  "tx_hash": "882ceb01f9f9992e03a7ff344dd4453c4b2052948f4ae5eacccac18980776864"
              },
              {
                  "height": 311472,
                  "tx_hash": "ca8035ca3f080c0cb5e26d38462c0fbebaea15eb0f43d8aacd172271e728a7e8"
              }
          ]
        EOS

        parsed_response = described_class.execute(response)

        expect(parsed_response.first[:height]).to eq 311470
      end
    end

    context "given a response with non-json characters" do
      it "discards non-json lines at the beginning" do
        response = <<-EOS.dedent
          Starting daemon [electrum0.electricnewyear.net:50002:s]
          Starting daemon [electrum0.electricnewyear.net:50002:s]
          wrong certificate electrum.stepkrav.pw
          Starting daemon [electrum0.electricnewyear.net:50002:s]
          [
              {
                  "height": 311470,
                  "tx_hash": "882ceb01f9f9992e03a7ff344dd4453c4b2052948f4ae5eacccac18980776864"
              },
              {
                  "height": 311472,
                  "tx_hash": "ca8035ca3f080c0cb5e26d38462c0fbebaea15eb0f43d8aacd172271e728a7e8"
              }
          ]
        EOS

        parsed_response = described_class.execute(response)

        expect(parsed_response.first[:height]).to eq 311470
      end

      it "discards non-json lines at the end" do
        response = <<-EOS.dedent
          Starting daemon [electrum.mindspot.org:50002:s]
          Starting daemon [electrum.mindspot.org:50002:s]
          {
              "complete": true,
              "hex": "010000000435e"
          }
          Starting daemon [electrum.mindspot.org:50002:s]
        EOS

        parsed_response = described_class.execute(response)

        expect(parsed_response[:complete]).to be true
      end
    end

  end
end
