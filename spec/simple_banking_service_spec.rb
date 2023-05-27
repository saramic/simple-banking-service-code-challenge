# frozen_string_literal: true

require "simple_banking_service"
require "tempfile"

RSpec.describe SimpleBankingService do
  context "with 2 empty files" do
    let(:account_balance) { temp_file_with_contents("account_balance.csv") { "" } }
    let(:transfers) { temp_file_with_contents("transfers.csv") { "" } }

    it "returns an empty string and no error for empty accounts and transfers" do
      expect(SimpleBankingService.run(account_balance, transfers)).to eq("")
    end
  end

  it "throws an error if 2 files are not provided to run" do
    expect {
      SimpleBankingService.run
    }.to raise_exception ArgumentError, "need to provide at least 2 input files"
  end
end

def temp_file_with_contents(filename)
  Tempfile.new(split_filename_separator_extension(filename)).tap do |file|
    file.write yield
    file.flush
  end
end

def split_filename_separator_extension(filename)
  separator_index = filename.index(".")
  [
    filename.slice(0, separator_index),
    filename.slice(separator_index, filename.length)
  ]
end
