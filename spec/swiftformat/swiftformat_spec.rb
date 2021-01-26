require File.expand_path("../spec_helper", __dir__)

RSpec.describe Danger::SwiftFormat do
  describe "#installed?" do
    context "when no path is given" do
      it "should use the default path" do
        sut = Danger::SwiftFormat.new
        cmd = class_double("Danger::Cmd").as_stubbed_const(transfer_nested_constants: true)

        expect(cmd).to receive(:run).with(%w(swiftformat --version))

        sut.installed?
      end
    end

    context "when path provided" do
      let(:path) { "/path/to/swiftformat" }

      it "should use the provided path" do
        sut = Danger::SwiftFormat.new(path)
        cmd = class_double("Danger::Cmd").as_stubbed_const(transfer_nested_constants: true)

        expect(cmd).to receive(:run).with(%w(/path/to/swiftformat --version))

        sut.installed?
      end
    end
  end

  describe "#check_format" do
    before do
      @sut = Danger::SwiftFormat.new
      @cmd = class_double("Danger::Cmd").as_stubbed_const(transfer_nested_constants: true)
    end

    it "should run swiftformat on the specified files" do
      files = %w(/path/to/file.swift /path/to/directory/)
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat /path/to/file.swift /path/to/directory/ --lint --lenient))
        .and_return(fixture("swiftformat_output.txt"))

      @sut.check_format(files)
    end

    it "should return a formatted output including rules when there are errors" do
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat . --lint --lenient))
        .and_return(fixture("swiftformat_output_with_errors.txt"))

      output = {
          errors: [
            { file: "spec/fixtures/1_BadFile.swift:3:1", rules: ["warning: (spaceAroundOperators) Add or remove space around operators or delimiters."] },
            { file: "spec/fixtures/1_BadFile.swift:4:1", rules: ["warning: (spaceInsideParens) Remove space inside parentheses."] },
            { file: "spec/fixtures/1_BadFile.swift:5:1", rules: ["warning: (indent) Indent code in accordance with the scope level."] }
          ],
          stats: {
              run_time: "0.02"
          }
      }
      expect(@sut.check_format(%w(.))).to eq(output)
    end

    it "should also return a formatted output if there were no errors" do
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat . --lint --lenient))
        .and_return(fixture("swiftformat_output.txt"))

      output = {
          errors: [],
          stats: {
              run_time: "0.01"
          }
      }

      expect(@sut.check_format(%w(.))).to eq(output)
    end

    it "should raise an error if the output is empty" do
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat . --lint --lenient))
        .and_return("")

      expect { @sut.check_format(%w(.)) }.to raise_error("Error running SwiftFormat: Empty output.")
    end

    it "should support nil additional command line arguments" do
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat . --lint --lenient))
        .and_return(fixture("swiftformat_output.txt"))

      output = {
          errors: [],
          stats: {
              run_time: "0.01"
          }
      }

      expect(@sut.check_format(%w(.), nil, nil)).to eq(output)
    end

    it "should support additional command line arguments" do
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat . --self insert --indent tab --swiftversion 5 --lint --lenient))
        .and_return(fixture("swiftformat_output.txt"))

      output = {
          errors: [],
          stats: {
              run_time: "0.01"
          }
      }

      expect(@sut.check_format(%w(.), "--self insert --indent tab", "5")).to eq(output)
    end

    it "should not crash if the output is invalid" do
      expect(@cmd).to receive(:run)
        .with(%w(swiftformat . --self insert --indent tab --lint --lenient))
        .and_return(fixture("swiftformat_output_bad.txt"))

      output = {
          errors: [],
          stats: {
              run_time: "-1"
          }
      }

      expect(@sut.check_format(%w(.), "--self insert --indent tab")).to eq(output)
    end
  end
end
