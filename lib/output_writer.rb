class OutputWriter
  def self.write(accounts)
    CSV.generate do |csv|
      accounts.each do |account|
        csv << [account.number, account.balance]
      end
    end
  end
end
