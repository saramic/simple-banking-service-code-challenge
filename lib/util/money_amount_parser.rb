require "config"
require "money"

module Util
  module MoneyAmountParser
    def parse_money_amount(amount)
      Money.from_amount(BigDecimal(amount)).cents.tap do |cents|
        raise ArgumentError, invalid_amount_message(amount) if cents < 0
        raise ArgumentError, invalid_amount_message(amount) if amount_has_parital_cents?(amount, cents)
      end
    rescue ArgumentError => e
      if /invalid value for BigDecimal()/.match?(e.message)
        raise ArgumentError, invalid_amount_message(amount)
      else
        raise e
      end
    end

    def amount_has_parital_cents?(amount, cents)
      BigDecimal(amount) * 100 != Money.from_cents(cents).cents
    end

    def invalid_amount_message(amount) = "money amount must be a valid positive number rounded to cents #{amount.inspect}"
  end
end
