require 'money'
require 'rpc/config'
require 'rpc/payment'
require 'rpc/client'
require 'rpc/version'
require 'rpc/wallet'
require 'rpc/transfer'
require 'rpc/incoming_transfer'

module RPC
  def self.config
    @@config ||= RPC::Config.instance
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
