module Relectrum
  class Executor

    def self.execute(path, command)
      dir = File.dirname(path)
      bin = File.basename(path)
      `cd #{dir} && ./#{bin} #{command} &>/dev/null`
    end

  end
end
