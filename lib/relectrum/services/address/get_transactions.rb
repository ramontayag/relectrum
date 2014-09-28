module Relectrum
  module Address
    class GetTransactions

      include LightService::Action
      expects :electrum, :address
      promises :address_history

      executed do |ctx|
        ctx.address_history = ctx.electrum.get_address_history(ctx.address)
      end

    end
  end
end
