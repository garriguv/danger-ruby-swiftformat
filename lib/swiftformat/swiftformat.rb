require "logger"

module Danger
  class SwiftFormat
    def initialize(path = nil)
      @path = path || "swiftformat"
    end

    def installed?
      Cmd.run([@path, "--version"])
    end

    def check_format(files, additional_args = "", swiftversion = "")
      cmd = [@path] + files
      cmd << additional_args.split unless additional_args.nil? || additional_args.empty?

      unless swiftversion.empty?
        cmd << "--swiftversion"
        cmd << swiftversion
      end

      cmd << %w(--lint --lenient)
      stdout, stderr, status = Cmd.run(cmd.flatten)

      output = stdout.empty? ? stderr : stdout
      raise "Error running SwiftFormat: Empty output." unless output

      output = output.strip.no_color

      if status && !status.success?
        raise "Error running SwiftFormat:\nError: #{output}"
      else
        raise "Error running SwiftFormat: Empty output." if output.empty?
      end

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

    ERRORS_REGEX = /(.*:\d+:\d+): ((warning|error):.*)$/.freeze

    def errors(output)
      errors = []
      output.scan(ERRORS_REGEX) do |match|
        next if match.count < 2

        errors << {
            file: match[0].sub("#{Dir.pwd}/", ""),
            rules: match[1].split(",").map(&:strip)
        }
      end
      errors
    end

    RUNTIME_REGEX = /.*SwiftFormat completed.*(.+\..+)s/.freeze

    def run_time(output)
      if RUNTIME_REGEX.match(output)
        RUNTIME_REGEX.match(output)[1]
      else
        logger = Logger.new($stderr)
        logger.error("Invalid run_time output: #{output}")
        "-1"
      end
    end
  end
end
