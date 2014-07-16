require "json"
require "active_support/core_ext/hash/indifferent_access"
require "relectrum/version"
require "relectrum/executor"
require "relectrum/client"

module Relectrum

  def self.new(path)
    Client.new(path)
  end

end
