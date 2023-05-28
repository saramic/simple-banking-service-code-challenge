require "util/money_amount_parser"

class Account
  attr_reader :number, :balance_in_cents

  include Util::MoneyAmountParser

  def initialize(account_number:, balance:)
    raise ArgumentError, "account number must be 16 digits long #{account_number.inspect}" unless /\d{16}/.match?(account_number)

    @number = account_number
    @balance_in_cents = parse_money_amount(balance)
  end

  def balance
    Money.from_cents(balance_in_cents)
  end

  def perform_transfer(transfer)
  end
end
