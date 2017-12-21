module Danger
  class SwiftFormat
    def initialize(path = nil)
      @path = path || "swiftformat"
    end

    def installed?
      Cmd.run([@path, "--version"])
    end
  end
end
