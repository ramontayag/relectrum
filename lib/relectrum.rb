require "json"
require "active_support/core_ext/hash/indifferent_access"
require "relectrum/version"
require "relectrum/executor"
require "relectrum/wrapper"

module Relectrum

  def self.new(path)
    Wrapper.new(path)
  end

end
