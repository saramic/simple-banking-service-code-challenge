# frozen_string_literal: true

require "simple_banking_service"

RSpec.describe SimpleBankingService do
  it "throws an error if 2 files are not provided to run" do
    expect {
      SimpleBankingService.run
    }.to raise_exception ArgumentError, "need to provide at least 2 input files"
  end
end
