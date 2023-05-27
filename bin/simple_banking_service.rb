#!/usr/bin/env ruby

$LOAD_PATH << File.join(__dir__, "../lib")

require "simple_banking_service"

puts SimpleBankingService.run(*ARGV)
