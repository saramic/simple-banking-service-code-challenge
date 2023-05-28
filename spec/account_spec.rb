require "account"

RSpec.describe Account do
  context "with valid acccount number and balance" do
    it "creates an account", :aggregate_failures do
      account = Account.new(account_number: "1234560000000001", balance: "10.00")
      expect(account.number).to eq "1234560000000001"
      expect(account.balance_in_cents).to eq 1000
    end
  end

  context "with account number that is too short" do
    let(:account_number) { "123" }

    it "complains bitterly" do
      expect {
        Account.new(account_number: account_number, balance: "10.00")
      }.to raise_error ArgumentError, 'account number must be 16 digits long "123"'
    end
  end

  context "with account numbers that are numeric like but not valid" do
    %w[
      12345600000000x1
      12345600000000.1
      12345600000000e1
      12345600000000😎1
      12345600000000,1
    ].each do |account_number|
      it "complains bitterly for #{account_number.inspect}" do
        expect {
          Account.new(account_number: account_number, balance: "10.00")
        }.to raise_error ArgumentError, "account number must be 16 digits long #{account_number.inspect}"
      end
    end
  end

  # NOTE: this is now the responsibility of util/balance_parser
  context "with balances that are not valid" do
    %w[
      -1
      10.001
      1x0.00
      1e0.00
      1,0.00
    ].each do |balance|
      it "complains bitterly for #{balance.inspect}" do
        expect {
          Account.new(account_number: "1234560000000001", balance: balance)
        }.to raise_error ArgumentError, "money amount must be a valid positive number rounded to cents #{balance.inspect}"
      end
    end
  end

  describe "#perform_transfer" do
    let(:account_from) { Account.new(account_number: "1234560000000001", balance: "10") }
    let(:account_to) { Account.new(account_number: "1234560000000002", balance: "0") }
    let(:transfer) { Transfer.new(from: account_from, to: account_to, amount: "9.95") }

    context "with a valid transfer" do
      it "transfers the money", :aggregate_failures do
        account_from.perform_transfer!(transfer)
        expect(account_from.balance_in_cents).to eq 5
        expect(account_to.balance_in_cents).to eq 995
      end
    end

    context "when from account would go negative" do
      let(:transfer) { Transfer.new(from: account_from, to: account_to, amount: "10.01") }

      it "complains bitterly" do
        expect {
          account_from.perform_transfer!(transfer)
        }.to raise_error ArgumentError, 'transfer of "$10.01" would bring account "1234560000000001" below 0 with current balance "$10.00"'
      end
    end
  end
end
