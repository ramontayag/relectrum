require "json"
require "light-service"
require "virtus"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/slice"
require "rbsx"
require "relectrum/version"
require "relectrum/executor"
require "relectrum/wrapper"
require "relectrum/client"
require "relectrum/models/transaction"
require "relectrum/services/get_address_transactions"
require "relectrum/services/address/get_transactions"
require "relectrum/services/address/initialize_transactions"
require "relectrum/services/determine_transaction_type"
require "relectrum/services/determine_transaction_amount"
require "relectrum/services/parse_response"

module Relectrum

  mattr_accessor :electrum_path, :sx_path

  def self.new(electrum_path: Relectrum.electrum_path,
               sx_path: Relectrum.sx_path)
    Client.new(electrum_path: electrum_path, sx_path: sx_path)
  end

  def self.configure(&block)
    yield self
  end

end
