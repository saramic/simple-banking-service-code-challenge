require "util/money_amount_parser"
require "account"

class Transfer
  attr_reader :from, :to, :amount_in_cents

  include Util::MoneyAmountParser

  def initialize(from:, to:, amount:)
    raise ArgumentError, "account needs to be an Account: #{from.inspect}" unless from.is_a? Account
    raise ArgumentError, "account needs to be an Account: #{to.inspect}" unless to.is_a? Account

    @from = from
    @to = to
    @amount_in_cents = parse_money_amount(amount)
  end

  def apply!
    from.perform_transfer!(self)
  end
end
