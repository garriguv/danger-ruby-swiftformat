module Danger
  class SwiftFormat
    def initialize(path = nil)
      @path = path || "swiftformat"
    end

    def installed?
      Cmd.run([@path, "--version"])
    end

    def check_format(files)
      output = Cmd.run([@path] + files + %w(--dryrun --verbose))
      process(output)
    end

    private

    def process(output)
      {
          errors: errors(output),
          stats: {
              run_time: run_time(output)
          }
      }
    end

    ERRORS_REGEX = /rules applied:(.*)\n.*updated (.*)$/

    def errors(output)
      errors = []
      output.scan(ERRORS_REGEX) do |match|
        next if match.count < 2
        errors << {
            file: match[1],
            rules: match[0].split(",").map(&:strip)
        }
      end
      errors
    end

    RUNTIME_REGEX = /^swiftformat completed.*(.+\..+)$/

    def run_time(output)
      RUNTIME_REGEX.match(output)[1]
    end
  end
end
