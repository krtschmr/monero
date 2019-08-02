require 'money'
require 'monero_rpc/config'
require 'monero_rpc/payment'
require 'monero_rpc/wallet'
require 'monero_rpc/version'
require 'monero_rpc/transfer'
require 'monero_rpc/transfer_class'
require 'monero_rpc/client'

module MoneroRPC
  def self.config
    @@config ||= MoneroRPC::Config.instance
  end

  def self.new(args={})
    host     = args.fetch(:host,     MoneroRPC.config.host) || raise("missing host")
    port     = args.fetch(:port,     MoneroRPC.config.port) || raise("missing port")
    username = args.fetch(:username, MoneroRPC.config.username) || raise("missing username")
    password = args.fetch(:password, MoneroRPC.config.password) || raise("missing password")
    debug    = args.fetch(:debug,    MoneroRPC.config.debug)
    in_transfer_clazz = args.fetch(:in_transfer_clazz, MoneroRPC.config.in_transfer_clazz)
    out_transfer_clazz = args.fetch(:out_transfer_clazz, MoneroRPC.config.out_transfer_clazz)

    Client.new(host: host, port: port, username: username, password: password, debug: debug, in_transfer_clazz: in_transfer_clazz, out_transfer_clazz: out_transfer_clazz)
  end

end

Money::Currency.register({
  :priority => 1,
  :iso_code => "xmr",
  :iso_numeric => "846",
  :name => "Monero",
  :symbol => "XMR",
  :subunit => "",
  :subunit_to_unit => 1000000000000,
  :decimal_mark => ".",
  :thousands_separator => ""
})

unless Object.const_defined?('XMR')
  class XMR
    def self.new(amount); Money.new(amount, :xmr); end
    def to_s; Money.new(amount, :xmr).format.to_s; end
  end
end

I18n.enforce_available_locales = false
Money.locale_backend = :i18n
I18n.locale = :en
