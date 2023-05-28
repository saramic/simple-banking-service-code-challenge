require "config"
require "money"

class Account
  attr_reader :number, :balance_in_cents
  def initialize(account_number:, balance:)
    raise ArgumentError, "account number must be 16 digits long #{account_number.inspect}" unless /\d{16}/.match?(account_number)

    @number = account_number
    @balance_in_cents = parse_balance(balance)
  end

  def balance
    Money.from_cents(balance_in_cents)
  end

  private

  def parse_balance(balance)
    Money.from_amount(BigDecimal(balance)).cents.tap do |cents|
      raise ArgumentError, invalid_balance_message(balance) if cents < 0
      raise ArgumentError, invalid_balance_message(balance) if balance_has_parital_cents?(balance, cents)
    end
  rescue ArgumentError => e
    if /invalid value for BigDecimal()/.match?(e.message)
      raise ArgumentError, invalid_balance_message(balance)
    else
      raise e
    end
  end

  def balance_has_parital_cents?(balance, cents)
    BigDecimal(balance) * 100 != Money.from_cents(cents).cents
  end

  def invalid_balance_message(balance) = "balance must be a valid positive number rounded to cents #{balance.inspect}"
end
