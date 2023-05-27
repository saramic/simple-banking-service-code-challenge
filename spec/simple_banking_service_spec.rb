# frozen_string_literal: true

require "simple_banking_service"
require "account_input_parser"
require "transfer_input_parser"
require "tempfile"

RSpec.describe SimpleBankingService do
  context "with 2 empty files" do
    let(:account_balance) { temp_file_with_contents("account_balance.csv") { "" } }
    let(:transfers) { temp_file_with_contents("transfers.csv") { "" } }

    it "returns an empty string and no error for empty accounts and transfers" do
      expect(SimpleBankingService.run(account_balance, transfers)).to eq("")
    end

    it "passes the first file to the AccountInputParser and second to TransferInputParser", :aggregate_failures do
      allow(AccountInputParser).to receive(:parse)
      allow(TransferInputParser).to receive(:parse)

      SimpleBankingService.run(account_balance, transfers)

      expect(AccountInputParser).to have_received(:parse).with(account_balance)
      expect(TransferInputParser).to have_received(:parse).with(transfers)
    end

    context "with only an account balance file" do
      let(:account_balance) do
        temp_file_with_contents("account_balance.csv") do
          <<~EO_ACCOUNT_BALANCE_CSV
            1234560000000001,1.00
            1234560000000002,2.00
          EO_ACCOUNT_BALANCE_CSV
        end
      end

      it "returns the account balances unchanged" do
        pending "a parser and writer for account balances"
        expect(SimpleBankingService.run(account_balance, transfers)).to eq(
          <<~EXPECTED_OUTPUT
            1234560000000001,1.00
            1234560000000002,2.00
          EXPECTED_OUTPUT
        )
      end
    end
  end

  it "throws an error if 2 files are not provided to run" do
    expect {
      SimpleBankingService.run
    }.to raise_exception ArgumentError, "need to provide at least 2 input files"
  end
end

def temp_file_with_contents(filename)
  Tempfile.new(split_filename_separator_extension(filename)).tap do |file|
    file.write yield
    file.flush
  end
end

def split_filename_separator_extension(filename)
  separator_index = filename.index(".")
  [
    filename.slice(0, separator_index),
    filename.slice(separator_index, filename.length)
  ]
end
