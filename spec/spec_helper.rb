require "bundler/setup"
require "monero"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # configure the RPC singleton
  RPC.config.host = "changeme"
  RPC.config.port = "38083"
  RPC.config.username = "changeme"
  RPC.config.password = "changeme"
  RPC.config.transfer_clazz = "MoneroTransfer"
end
