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

  def perform_transfer!(transfer)
    transfer.to.credit_cents(debit_cents(transfer.amount_in_cents))
  end

  protected

  def debit_cents(amount_in_cents)
    if @balance_in_cents - amount_in_cents <= 0
      raise ArgumentError, "transfer of #{Money.from_cents(amount_in_cents).format.inspect} " \
        "would bring account #{number.inspect} below 0 with current balance #{balance.format.inspect}"
    end

    @balance_in_cents -= amount_in_cents
    amount_in_cents
  end

  def credit_cents(amount_in_cents)
    @balance_in_cents += amount_in_cents
  end
end
