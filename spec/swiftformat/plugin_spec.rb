require File.expand_path("../../spec_helper", __FILE__)

module Danger
  describe Danger::DangerSwiftformat do
    it "should be a plugin" do
      expect(Danger::DangerSwiftformat.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @sut = @dangerfile.swiftformat
      end

      it "fails if SwiftFormat is not installed" do
        allow_any_instance_of(SwiftFormat).to receive(:installed?).and_return(false)

        expect { @sut.check_format }.to raise_error("Could not find SwiftFormat executable")
      end

      context "with binary_path" do
        let(:binary_path) { "path/to/swiftformat" }

        it "passes the binary_path to the constructor" do
          swiftformat = double("swiftformat")
          allow(SwiftFormat).to receive(:new).with(binary_path).and_return(swiftformat)

          @sut.binary_path = binary_path

          expect(@sut.swiftformat).to eq(swiftformat)
        end
      end

      describe "#check_format" do
        before do
          allow_any_instance_of(SwiftFormat).to receive(:installed?).and_return(true)
        end
      end
    end
  end
end
