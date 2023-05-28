require "csv"
require "transfer"

class TransferInputParser
  def self.parse(accounts, transfer_input)
    raise ArgumentError, "transfer input needs to be a file" unless File.exist?(transfer_input)

    CSV.read(transfer_input).map do |line|
      Transfer.new(
        from: find_account(accounts, line[0]),
        to: find_account(accounts, line[1]),
        amount: line[2]
      )
    end
  end

  private_class_method def self.find_account(accounts, account_number)
    accounts.find { |account| account.number == account_number }.tap do |account|
      raise ArgumentError, "account for transfer needs to exist #{account_number.inspect}" unless account
    end
  end
end
