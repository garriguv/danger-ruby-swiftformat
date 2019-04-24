require File.expand_path("../spec_helper", __dir__)

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

      context "with additional_args" do
        let(:additional_args) { "--indent tab --self insert" }
        let(:success_output) { { errors: [], stats: { run_time: "0.08s" } } }

        it "should pass the additional flags to swiftformat" do
          allow(@sut.git).to receive(:added_files).and_return(["Added.swift"])
          allow(@sut.git).to receive(:modified_files).and_return(["Modified.swift"])
          allow(@sut.git).to receive(:deleted_files).and_return(["Deleted.swift"])
          allow_any_instance_of(SwiftFormat).to receive(:installed?).and_return(true)
          allow_any_instance_of(SwiftFormat).to receive(:check_format)
            .with(%w(Added.swift Modified.swift), additional_args)
            .and_return(success_output)

          @sut.additional_args = additional_args

          @sut.check_format(fail_on_error: true)

          status = @sut.status_report
          expect(status[:errors]).to be_empty
          expect(status[:markdowns]).to be_empty
        end
      end

      context "with additional_message" do
        let(:additional_message) { "I'm the additional message." }
        let(:error_output) { { errors: [{ file: "Modified.swift", rules: %w(firstRule secondRule) }], stats: { run_time: "0.16s" } } }

        it "should include the additional message in the report" do
          allow(@sut.git).to receive(:added_files).and_return(["Added.swift"])
          allow(@sut.git).to receive(:modified_files).and_return(["Modified.swift"])
          allow(@sut.git).to receive(:deleted_files).and_return(["Deleted.swift"])
          allow_any_instance_of(SwiftFormat).to receive(:installed?).and_return(true)
          allow_any_instance_of(SwiftFormat).to receive(:check_format).with(%w(Added.swift Modified.swift), nil).and_return(error_output)
          @sut.additional_message = additional_message
          @sut.check_format(fail_on_error: true)

          status = @sut.status_report
          markdown = status[:markdowns].first.message
          expect(markdown).to include(additional_message)
        end
      end

      describe "#check_format" do
        let(:success_output) { { errors: [], stats: { run_time: "0.08s" } } }
        let(:error_output) { { errors: [{ file: "Modified.swift", rules: %w(firstRule secondRule) }], stats: { run_time: "0.16s" } } }

        context "when there are no swift files to check" do
          before do
            allow_any_instance_of(SwiftFormat).to receive(:installed?).and_return(true)
            allow(@sut.git).to receive(:added_files).and_return(["Added.m"])
            allow(@sut.git).to receive(:modified_files).and_return(["Modified.m"])
            allow(@sut.git).to receive(:deleted_files).and_return(["Deleted.m"])
          end

          it "should not do anything" do
            @sut.check_format(fail_on_error: true)

            status = @sut.status_report
            expect(status[:errors]).to be_empty
            expect(status[:markdowns]).to be_empty
          end
        end

        context "when there are swift files to check" do
          before do
            allow_any_instance_of(SwiftFormat).to receive(:installed?).and_return(true)
            allow(@sut.git).to receive(:added_files).and_return(["Added.swift"])
            allow(@sut.git).to receive(:modified_files).and_return(["Modified.swift"])
            allow(@sut.git).to receive(:deleted_files).and_return(["Deleted.swift"])
          end

          context "when swiftformat does not find any errors" do
            before do
              allow_any_instance_of(SwiftFormat).to receive(:check_format).with(%w(Added.swift Modified.swift), nil).and_return(success_output)
            end

            it "should not do anything" do
              @sut.check_format(fail_on_error: true)

              status = @sut.status_report
              expect(status[:errors]).to be_empty
              expect(status[:markdowns]).to be_empty
            end
          end

          context "when swiftformat finds errors" do
            before do
              allow_any_instance_of(SwiftFormat).to receive(:check_format).with(%w(Added.swift Modified.swift), nil).and_return(error_output)
            end

            it "should output some markdown and error if fail_on_error is true" do
              @sut.check_format(fail_on_error: true)

              status = @sut.status_report
              expect(status[:errors]).to_not be_empty
              expect(status[:markdowns]).to_not be_empty
            end

            it "should output some markdown and not error if fail_on_error is false" do
              @sut.check_format(fail_on_error: false)

              status = @sut.status_report
              expect(status[:errors]).to be_empty
              expect(status[:markdowns]).to_not be_empty
            end
          end
        end
      end
    end
  end
end
