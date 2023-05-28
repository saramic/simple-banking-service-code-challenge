# frozen_string_literal: true

require "transfer_input_parser"
require "transfer"
require "account"

RSpec.describe TransferInputParser do
  let(:account_one) { Account.new(account_number: "1234560000000001", balance: "10.00") }
  let(:account_two) { Account.new(account_number: "1234560000000002", balance: "100.00") }
  let(:account_tre) { Account.new(account_number: "1234560000000003", balance: "1000.00") }
  let(:accounts) { [account_one, account_two, account_tre] }

  context "with a valid file with valid accounts" do
    let(:input) do
      temp_file_with_contents("transfers.csv") do
        <<~EO_FILE_CONTENTS
          1234560000000001,1234560000000002,10.00
          1234560000000002,1234560000000003,20.00
        EO_FILE_CONTENTS
      end
    end

    it "creates transfers for each line", :aggregate_failures do
      allow(Transfer).to receive(:new)

      TransferInputParser.parse(accounts, input)

      expect(Transfer).to have_received(:new).with(
        from: account_one,
        to: account_two,
        amount: "10.00"
      )
      expect(Transfer).to have_received(:new).with(
        from: account_two,
        to: account_tre,
        amount: "20.00"
      )
    end
  end

  context "when the input is not a file" do
    let(:input) { "" }

    it "complains bitterly" do
      expect {
        TransferInputParser.parse(accounts, input)
      }.to raise_error ArgumentError, /transfer input needs to be a file/
    end
  end

  context "when the account does not exist" do
    let(:input) do
      temp_file_with_contents("transfers.csv") do
        <<~EO_FILE_CONTENTS
          1234560000000001,1234569999999999,10.00
          1234560000000002,1234560000000003,20.00
        EO_FILE_CONTENTS
      end
    end

    it "complains bitterly" do
      expect {
        TransferInputParser.parse(accounts, input)
      }.to raise_error ArgumentError, /account for transfer needs to exist "1234569999999999"/
    end
  end
end
