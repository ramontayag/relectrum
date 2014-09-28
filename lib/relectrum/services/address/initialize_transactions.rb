module Relectrum
  module Address
    class InitializeTransactions

      include LightService::Action
      expects :address_history, :block_height, :electrum, :address
      promises :transactions

      executed do |ctx|
        ctx.transactions = ctx.address_history.map do |transaction|
          opts = {
            address: ctx.address,
            electrum: ctx.electrum,
            hash: transaction.fetch(:tx_hash),
            height: transaction.fetch(:height),
            block_height: ctx.block_height,
          }
          Transaction.new(opts)
        end
      end

    end
  end
end
