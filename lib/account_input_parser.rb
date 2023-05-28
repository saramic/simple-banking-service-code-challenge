require "csv"
require "account"

class AccountInputParser
  def self.parse(account_input)
    raise ArgumentError, "account in put needs to be a file" unless File.exist?(account_input)
    raise ArgumentError, "account number needs to have 16 digits" if valid_account_column(account_input)

    CSV.read(account_input).map do |line|
      Account.new(
        account_number: line[0],
        balance: line[1]
      )
    end
  end

  private_class_method def self.valid_account_column(account_input)
    input = CSV.read(account_input)
    !input.map.find_all { |line| line[0] !~ /\d{16}/ }.empty?
  end
end
