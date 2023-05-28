require "transfer"

RSpec.describe Transfer do
  let(:account_one) { Account.new(account_number: "1234560000000001", balance: "0") }
  let(:account_two) { Account.new(account_number: "1234560000000002", balance: "0") }

  before do
    allow_any_instance_of(Util::MoneyAmountParser).to receive(:parse_money_amount) # rubocop:disable RSpec/AnyInstance
    allow(account_one).to receive(:perform_transfer!)
  end

  context "with valid to and from acccount and amount" do
    it "creates a transfer", :aggregate_failures do
      transfer = Transfer.new(from: account_one, to: account_two, amount: "10.00")
      expect(transfer.from).to eq account_one
      expect(transfer.to).to eq account_two
    end

    it "parses the money using money amount parser", :aggregate_failures do
      allow_any_instance_of(Util::MoneyAmountParser).to receive(:parse_money_amount).and_return("the amount in cents") # rubocop:disable RSpec/AnyInstance

      transfer = Transfer.new(from: account_one, to: account_two, amount: "10.00")

      expect(transfer.amount_in_cents).to eq "the amount in cents"
      expect(transfer).to have_received(:parse_money_amount).with("10.00")
    end

    it "can apply a transfer to the from account" do
      transfer = Transfer.new(from: account_one, to: account_two, amount: "10.00")
      transfer.apply!

      expect(account_one).to have_received(:perform_transfer!).with(transfer)
    end
  end

  context "with a to or from account that is not an Account" do
    it "complains bitterly if from is not an Account" do
      expect {
        Transfer.new(from: "1", to: account_two, amount: "10.00")
      }.to raise_error ArgumentError, "account needs to be an Account: \"1\""
    end

    it "complains bitterly if to is not an Account" do
      expect {
        Transfer.new(from: account_one, to: "2", amount: "10.00")
      }.to raise_error ArgumentError, "account needs to be an Account: \"2\""
    end
  end
end
