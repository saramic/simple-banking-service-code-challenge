require "account_input_parser"
require "transfer_input_parser"
require "ledger"
require "output_writer"

class SimpleBankingService
  def self.run(*input_files)
    validate_input_files(*input_files)
    accounts = AccountInputParser.parse(input_files.first)
    transfers = TransferInputParser.parse(accounts, input_files[1])
    ledger = Ledger.new(accounts, transfers)
    ledger.apply_transfers
    OutputWriter.write(ledger.accounts)
  end

  private_class_method def self.validate_input_files(*input_files)
    raise ArgumentError, "need to provide at least 2 input files" if input_files.length < 2
  end
end
