module Relectrum
  class DetermineTransactionAmount

    def self.execute(address, decoded_transaction)
      type = DetermineTransactionType.execute(address, decoded_transaction)
      outputs = decoded_transaction.fetch(:outputs)

      if type == "receive"
        address_outputs = outputs.select do |output|
          output[0] == "address" && output[1] == address
        end
      else
        address_outputs = outputs.select do |output|
          output[1] != address
        end
      end

      address_outputs.reduce(0) do |sum, output|
        sum += output[2]
        sum
      end
    end

  end
end
