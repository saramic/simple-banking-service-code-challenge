require "account"

RSpec.describe Account do
  context "with valid acccount number and balance" do
    it "creates an account", :aggregate_failures do
      account = Account.new(account_number: "1234560000000001", balance: "10.00")
      expect(account.number).to eq "1234560000000001"
      pending "parse money"
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
end
