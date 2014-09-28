require "spec_helper"

module Relectrum
  describe Executor, ".execute" do

    it "executes the electrum command" do
      expect(described_class).to receive(:`).
        with("cd /path/to && ./electrum mycommand somearg &>/dev/null")
      described_class.execute("/path/to/electrum", "mycommand somearg")
    end

  end
end
