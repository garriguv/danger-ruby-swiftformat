require File.expand_path("../../spec_helper", __FILE__)

RSpec.describe Danger::SwiftFormat do
  describe "#installed?" do
    context "when no path is given" do
      it "should use the default path" do
        sut = Danger::SwiftFormat.new
        cmd = class_double("Cmd").as_stubbed_const(transfer_nested_constants: true)

        expect(cmd).to receive(:run).with(%w(swiftformat --version))

        sut.installed?
      end
    end

    context "when path provided" do
      let(:path) { "/path/to/swiftformat" }

      it "should use the provided path" do
        sut = Danger::SwiftFormat.new(path)
        cmd = class_double("Cmd").as_stubbed_const(transfer_nested_constants: true)

        expect(cmd).to receive(:run).with(%w(/path/to/swiftformat --version))

        sut.installed?
      end
    end
  end
end
