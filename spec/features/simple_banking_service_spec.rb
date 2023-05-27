# frozen_string_literal: true

feature "simple banking service" do
  scenario "runs successfully" do
    When "the origianl account balance file" do
      @account_balance_file = File.join(__dir__, "../../mable_acc_balance.csv")
    end

    And "the original transfers file" do
      @account_transfer_file = File.join(__dir__, "../../mable_trans.csv")
    end

    When "the simple banking service is executed with these 2 files" do
      simple_banking_service = File.join(__dir__, "../../bin/simple_banking_service.rb")
      @result = `bundle exec ruby #{simple_banking_service} #{@account_balance_file} #{@account_transfer_file}`
    end

    Then "the result is CSV matching the correct results" do
      pending "no result is currently output"
      expect(@result).to eq(
        <<~EO_REPORT_OUTPUT
          1111234522226789,4820.50
          1111234522221234,9974.40
          2222123433331212,1550.00
          1212343433335665,1725.60
          3212343433335755,48779.50
        EO_REPORT_OUTPUT
      )
    end

    And "a successful exit code (0) is returned" do
      expect($CHILD_STATUS.exitstatus).to eq(0)
    end
  end
end
