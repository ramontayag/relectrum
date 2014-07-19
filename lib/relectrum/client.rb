module Relectrum
  class Client

    attr_reader :electrum

    def initialize(path)
      @electrum = path
    end

    def get_version
      Executor.execute(electrum, "getversion")
    end

    def get_address_balance(address)
      response = Executor.execute(electrum, "getaddressbalance #{address}")
      JSON.parse(response).with_indifferent_access
    end

    def get_address_history(address)
      response = Executor.execute(electrum, "getaddresshistory #{address}")
      JSON.parse(response).map(&:with_indifferent_access)
    end

    def validate_address(address)
      response = Executor.execute(electrum, "validateaddress #{address}")
      JSON.parse(response).with_indifferent_access[:isvalid]
    end

    def get_raw_transaction(txid)
      response = Executor.execute(electrum, "getrawtransaction #{txid}")
      JSON.parse(response).with_indifferent_access
    end

    def decode_raw_transaction(txid)
      response = Executor.execute(electrum, "decoderawtransaction #{txid}")
      JSON.parse(response).with_indifferent_access
    end

    def auto_cycle
      Executor.execute(electrum, "getconfig auto_cycle") == "True"
    end

    def auto_cycle=(bool)
      setting = bool ? "True" : "False"
      Executor.execute(electrum, "setconfig auto_cycle #{setting}")
    end

  end
end
