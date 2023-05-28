class Account
  attr_reader :number, :balance_in_cents
  def initialize(account_number:, balance:)
    raise ArgumentError, "account number must be 16 digits long #{account_number.inspect}" unless /\d{16}/.match?(account_number)

    @number = account_number
    @balance_in_cents = balance
  end
end
