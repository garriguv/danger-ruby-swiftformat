require "logger"

module Danger
  class SwiftFormat
    def initialize(path = nil)
      @path = path || "swiftformat"
    end

    def installed?
      Cmd.run([@path, "--version"])
    end

    def check_format(files, additional_args = "")
      cmd = [@path] + files
      cmd << additional_args.split unless additional_args.nil? || additional_args.empty?
      cmd << %w(--dryrun --verbose)
      stdout, stderr, status = Cmd.run(cmd.flatten)

      output = stdout.strip.no_color
      output = stderr.strip.no_color if output.empty?

      raise "Error running SwiftFormat:\nError: #{output}" unless status.success?
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

    RUNTIME_REGEX = /.*swiftformat completed.*(.+\..+)s/

    def run_time(output)
      if RUNTIME_REGEX.match(output)
        RUNTIME_REGEX.match(output)[1]
      else
        logger = Logger.new(STDERR)
        logger.error("Invalid run_time output: #{output}")
        "-1"
      end
    end
  end
end
