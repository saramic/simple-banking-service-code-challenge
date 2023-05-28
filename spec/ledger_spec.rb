require "ledger"
require "account"
require "transfer"

RSpec.describe Ledger do
  let(:transfer_one) { instance_double(Transfer) }
  let(:transfer_two) { instance_double(Transfer) }

  it "calls apply! on every transfer", :aggregate_failures do
    allow(transfer_one).to receive(:apply!)
    allow(transfer_two).to receive(:apply!)

    ledger = Ledger.new(accounts: nil, transfers: [transfer_one, transfer_two])
    ledger.apply_transfers

    expect(transfer_one).to have_received(:apply!)
    expect(transfer_two).to have_received(:apply!)
  end
end
