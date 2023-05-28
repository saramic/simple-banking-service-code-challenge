# frozen_string_literal: true

require "account_input_parser"
require "account"

RSpec.describe AccountInputParser do
  context "with a valid file" do
    let(:input) do
      temp_file_with_contents("account_balance.csv") do
        <<~EO_FILE_CONTENTS
          1234560000000001,10.00
          1234560000000002,20.00
        EO_FILE_CONTENTS
      end
    end

    it "creates accounts for each line", :aggregate_failures do
      allow(Account).to receive(:new)

      AccountInputParser.parse(input)

      expect(Account).to have_received(:new).with(
        account_number: "1234560000000001",
        balance: "10.00"
      )
      expect(Account).to have_received(:new).with(
        account_number: "1234560000000002",
        balance: "20.00"
      )
    end
  end

  context "when the input is not a file" do
    let(:input) { "" }

    it "complains bitterly" do
      expect {
        AccountInputParser.parse(input)
      }.to raise_error ArgumentError, /account in put needs to be a file/
    end
  end
end
