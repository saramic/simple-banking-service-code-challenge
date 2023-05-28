class Ledger
  attr_reader :accounts

  def initialize(accounts, transfers)
    @accounts = accounts
  end
end
