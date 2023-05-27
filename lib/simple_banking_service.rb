require "account_input_parser"
require "transfer_input_parser"

class SimpleBankingService
  def self.run(*input_files)
    validate_input_files(*input_files)
    AccountInputParser.parse(input_files.first)
    TransferInputParser.parse(input_files[1])
    # ledger = Ledger.new(accounts, transfers)
    # ledger.apply_transfers
    # OutputWriter.write(ledger.accounts)
    ""
  end

  private_class_method def self.validate_input_files(*input_files)
    raise ArgumentError, "need to provide at least 2 input files" if input_files.length < 2
  end
end
