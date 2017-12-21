module Danger
  class Cmd
    def self.run(cmd)
      stdout, stderr, status = Open3.capture3(*cmd)

      stdout.strip
    end
  end
end
