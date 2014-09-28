module Relectrum
  class GetAddressTransactions

    include LightService::Organizer

    def self.execute(electrum: electrum,
                     address: address,
                     block_height: block_height)
      ctx = {
        electrum: electrum,
        address: address,
        block_height: block_height,
      }
      with(ctx).reduce(
        Address::GetTransactions,
        Address::InitializeTransactions,
      )
    end

  end
end
