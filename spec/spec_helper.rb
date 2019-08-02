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
  MoneroRPC.config.host = "change to your ip address"
  MoneroRPC.config.port = "28081"
  MoneroRPC.config.username = "username"
  MoneroRPC.config.password = "password"
end
