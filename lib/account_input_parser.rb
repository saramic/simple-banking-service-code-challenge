require "csv"
require "account"

class AccountInputParser
  def self.parse(account_input)
    raise ArgumentError, "account in put needs to be a file" unless File.exist?(account_input)

    CSV.read(account_input).map do |line|
      Account.new(
        account_number: line[0],
        balance: line[1]
      )
    end
  end
end
