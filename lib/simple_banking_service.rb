class SimpleBankingService
  def self.run(*input_files)
    validate_input_files(*input_files)
    ""
  end

  private_class_method def self.validate_input_files(*input_files)
    raise ArgumentError, "need to provide at least 2 input files" if input_files.length < 2
  end
end
