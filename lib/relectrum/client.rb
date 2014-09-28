module Relectrum
  class Client

    attr_accessor :electrum_path, :sx_path

    def initialize(electrum_path: Relectrum.electrum_path,
                   sx_path: Relectrum.sx_path)

      self.electrum_path = electrum_path
      self.sx_path = sx_path
    end

    def last_block_height
      sx.bci_fetch_last_height
    end

    def address_transactions(address)
      GetAddressTransactions.execute(
        electrum: electrum,
        address: address,
        block_height: last_block_height,
      ).transactions
    end

    private

    def sx
      Rbsx.new(sx_path: sx_path)
    end

    def electrum
      Wrapper.new(electrum_path: electrum_path)
    end

  end
end
