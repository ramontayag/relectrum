module Relectrum
  class Wrapper

    attr_accessor :electrum_path

    def initialize(electrum_path: electrum_path)
      self.electrum_path = electrum_path
    end

    def get_version
      Executor.execute(electrum_path, "getversion")
    end

    def get_address_balance(address)
      response = Executor.execute(electrum_path, "getaddressbalance #{address}")
      ParseResponse.execute(response)
    end

    def get_address_history(address)
      response = Executor.execute(electrum_path, "getaddresshistory #{address}")
      ParseResponse.execute(response)
    end

    def validate_address(address)
      response = Executor.execute(electrum_path, "validateaddress #{address}")
      ParseResponse.execute(response).fetch(:isvalid)
    end

    def get_raw_transaction(txid)
      response = Executor.execute(electrum_path, "getrawtransaction #{txid}")
      ParseResponse.execute(response)
    end

    def decode_raw_transaction(txid)
      response = Executor.execute(electrum_path, "decoderawtransaction #{txid}")
      ParseResponse.execute(response)
    end

    def auto_cycle
      Executor.execute(electrum_path, "getconfig auto_cycle") == "True"
    end

    def auto_cycle=(bool)
      setting = bool ? "True" : "False"
      Executor.execute(electrum_path, "setconfig auto_cycle #{setting}")
    end

  end
end
