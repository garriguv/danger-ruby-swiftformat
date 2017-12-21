module Danger
  # A danger plugin to check Swift formatting using SwiftFormat.
  #
  # @example Check that the added and modified files are properly formatted:
  #
  #          swiftformat.check_format
  #
  # @see  garriguv/danger-swiftformat
  # @tags swiftformat
  #
  class DangerSwiftformat < Plugin
    # The path to SwiftFormat's executable
    #
    # @return [String]
    attr_accessor :binary_path

    # Allows you to specify a directory from where swiftformat will be run
    #
    # @return [Array<String>]
    attr_accessor :directory

    # Runs swiftformat
    #
    # @param [Array<String>] files
    #   The files and/or directories on/in which to run swiftformat, defaults to nil.
    #   If nil, modified and added Swift files will be checked.
    # @param [Boolean] fail_on_error
    #
    # @return [void]
    #
    def check_format(files: nil, fail_on_error: false)
      # Check if SwiftFormat is installed
      raise "Could not find SwiftFormat executable" unless swiftformat.installed?

      # Find Swift files
      swift_files = find_swift_files(files)
    end

    # Find the files on which SwiftFormat should be run
    #
    # @param [Array<String>] files
    #   The files and/or directories on/in which to run swiftformat, defaults to nil.
    #   If nil, modified and added Swift files will be checked.
    #
    # @return [Array<String]
    def find_swift_files(files)
      files = if files.nil?
                (git.modified_files - git.deleted_files) + git.added_files
              else
                Dir.glob(files)
              end

      files
        .select { |file| file.end_with?(".swift") }
        .map { |file| Shellwords.escape(File.expand_path(file)) }
        .uniq
    end

    # Constructs the SwiftFormat class
    #
    # @return [SwiftFormat]
    def swiftformat
      @swiftformat ||= SwiftFormat.new(binary_path)
    end
  end
end
