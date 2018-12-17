require "colored2"
require "shellwords"

module Danger
  class Cmd
    def self.run(cmd)
      Open3.capture3(cmd.shelljoin)
    end
  end
end
