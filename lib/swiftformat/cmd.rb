module Danger
  class Cmd
    def self.run(cmd)
      stdout = Open3.capture3(*cmd)

      stdout.strip
    end
  end
end
