class Ledger
  attr_reader :accounts

  def initialize(accounts:, transfers:)
    @accounts = accounts
    @transfers = transfers
  end

  def apply_transfers
    @transfers.each do |transfer|
      transfer.apply!
    end
  end
end
