module Relectrum
  class DetermineTransactionType

    def self.execute(address, decoded_transaction)
      inputs = decoded_transaction.fetch(:inputs)
      input_addresses = inputs.map{|i| i[:address]}

      if input_addresses.include?(address)
        "send"
      else
        "receive"
      end
    end

  end
end
