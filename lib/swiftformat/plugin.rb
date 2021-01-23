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

    # Additional swiftformat command line arguments
    #
    # @return [String]
    attr_accessor :additional_args

    # Additional message to be appended the report
    #
    # @return [String]
    attr_accessor :additional_message

    # An array of file and directory paths to exclude
    #
    # @return [Array<String]
    attr_accessor :exclude

    # Runs swiftformat
    #
    # @param [Boolean] fail_on_error
    #
    # @return [void]
    #
    def check_format(fail_on_error: false)
      # Check if SwiftFormat is installed
      raise "Could not find SwiftFormat executable" unless swiftformat.installed?

      # Find Swift files
      swift_files = find_swift_files

      # Stop processing if there are no swift files
      return if swift_files.empty?

      # Run swiftformat
      results = swiftformat.check_format(swift_files, additional_args)

      # Stop processing if the errors array is empty
      return if results[:errors].empty?

      # Process the errors
      message = "### SwiftFormat found issues:\n\n"
      message << "| File | Rules |\n"
      message << "| ---- | ----- |\n"
      results[:errors].each do |error|
        message << "| #{error[:file].gsub("#{Dir.pwd}/", '')} | #{error[:rules].join(', ')} |\n"
      end

      unless additional_message.nil?
        message << "\n" << additional_message
      end

      markdown message

      if fail_on_error
        fail "SwiftFormat found issues"
      end
    end

    # Find the files on which SwiftFormat should be run
    #
    # @return [Array<String]
    def find_swift_files
      renamed_files_hash = git.renamed_files.map { |rename| [rename[:before], rename[:after]] }.to_h

      post_rename_modified_files = git.modified_files
        .map { |modified_file| renamed_files_hash[modified_file] || modified_file }

      files = (post_rename_modified_files - git.deleted_files) + git.added_files

      @exclude = %w() if @exclude.nil?

      files
        .select { |file| file.end_with?(".swift") }
        .reject { |file| @exclude.any? { |glob| File.fnmatch(glob, file) } }
        .uniq
        .sort
    end

    # Constructs the SwiftFormat class
    #
    # @return [SwiftFormat]
    def swiftformat
      SwiftFormat.new(binary_path)
    end
  end
end
