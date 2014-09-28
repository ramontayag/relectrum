module Relectrum
  class Transaction

    include Virtus.model

    attribute :hash, String
    attribute :electrum, Wrapper
    attribute :address, String
    attribute :height, Integer
    attribute :block_height, Integer

    def id
      hash
    end

    def hex
      raw_details.fetch(:hex)
    end

    def confirmations
      return 0 if height.zero?
      block_height + 1 - height
    end

    def type
      DetermineTransactionType.execute(address, decoded_details)
    end

    def amount
      DetermineTransactionAmount.execute(address, decoded_details)
    end

    private

    def raw_details
      @raw_details ||= electrum.get_raw_transaction(self.id)
    end

    def decoded_details
      @decoded_details ||= electrum.decode_raw_transaction(hex)
    end

  end
end
