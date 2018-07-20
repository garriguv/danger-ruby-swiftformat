require "shellwords"

module Danger
  class Cmd
    def self.run(cmd)
      stdout, _stderr, _status = Open3.capture3(cmd.shelljoin)

      stdout.strip
    end
  end
end
