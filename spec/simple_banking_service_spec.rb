# frozen_string_literal: true

require "simple_banking_service"
require "account_input_parser"
require "transfer_input_parser"
require "ledger"
require "output_writer"

RSpec.describe SimpleBankingService do
  context "with 2 empty files" do
    let(:account_balance) { temp_file_with_contents("account_balance.csv") { "" } }
    let(:transfers) { temp_file_with_contents("transfers.csv") { "" } }
    let(:mock_ledger) { instance_double(Ledger) }

    before do
      allow(AccountInputParser).to receive(:parse)
      allow(TransferInputParser).to receive(:parse)
      allow(Ledger).to receive(:new).and_return(mock_ledger)
      allow(mock_ledger).to receive(:accounts).and_return([])
      allow(mock_ledger).to receive(:apply_transfers)
    end

    it "returns the output of ledger.accounts via the OutputWriter" do
      allow(OutputWriter).to receive(:write).and_return("the banking service output")

      expect(SimpleBankingService.run(account_balance, transfers)).to eq("the banking service output")
    end

    it "passes the first file to the AccountInputParser and second to TransferInputParser", :aggregate_failures do
      allow(AccountInputParser).to receive(:parse).and_return("the accounts")

      SimpleBankingService.run(account_balance, transfers)

      expect(AccountInputParser).to have_received(:parse).with(account_balance)
      expect(TransferInputParser).to have_received(:parse).with("the accounts", transfers)
    end

    it "passes the accounts and transfers to a ledger" do
      allow(AccountInputParser).to receive(:parse).and_return("the accounts")
      allow(TransferInputParser).to receive(:parse).and_return("the transfers")

      SimpleBankingService.run(account_balance, transfers)

      expect(Ledger).to have_received(:new).with(accounts: "the accounts", transfers: "the transfers")
    end

    it "applies the transfers on the ledger" do
      SimpleBankingService.run(account_balance, transfers)

      expect(mock_ledger).to have_received(:apply_transfers)
    end

    it "writes the output of ledger accounts through the OutputWriter", :aggregate_failures do
      allow(mock_ledger).to receive(:accounts).and_return("the ledger accounts")
      allow(OutputWriter).to receive(:write).and_return("the output writer output")

      expect(
        SimpleBankingService.run(account_balance, transfers)
      ).to eq "the output writer output"

      expect(OutputWriter).to have_received(:write).with("the ledger accounts")
    end
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
    let(:transfers) { temp_file_with_contents("transfers.csv") { "" } }

    it "returns the account balances unchanged" do
      expect(SimpleBankingService.run(account_balance, transfers)).to eq(
        <<~EXPECTED_OUTPUT
          1234560000000001,1.00
          1234560000000002,2.00
        EXPECTED_OUTPUT
      )
    end
  end

  it "throws an error if 2 files are not provided to run" do
    expect {
      SimpleBankingService.run
    }.to raise_exception ArgumentError, "need to provide at least 2 input files"
  end
end
