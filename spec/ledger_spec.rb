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

  describe "model integration" do
    let(:account_one) { Account.new(account_number: "1234560000000001", balance: "10") }
    let(:account_two) { Account.new(account_number: "1234560000000002", balance: "0") }
    let(:transfer_one) { Transfer.new(from: account_one, to: account_two, amount: "9.95") }

    context "with a valid transfer" do
      it "transfers the money", :aggregate_failures do
        ledger = Ledger.new(accounts: [account_one, account_two], transfers: [transfer_one])
        ledger.apply_transfers
        account_one_post_transfers = ledger.accounts.find { |account| account.number == account_one.number }
        pending "transfers actually applying to an acccount"
        expect(account_one_post_transfers.balance_in_cents).to eq 5

        account_two_post_transfers = ledger.accounts.find { |account| account.number == account_two.number }
        expect(account_two_post_transfers.balance_in_cents).to eq 995
      end
    end
  end
end
