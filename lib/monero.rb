require 'money'
require 'monero/config'
require 'monero/payment'
require 'monero/client'
require 'monero/version'
require 'monero/wallet'
require 'monero/transfer'

module Monero
  def self.config
    @@config ||= Monero::Config.instance
  end
end

# ActiveSupport.on_load(:active_record) do
#   include Monero::Model
# end

Money::Currency.register({ :priority            => 1, :iso_code            => "xmr", :iso_numeric         => "846", :name                => "Monero", :symbol              => "XMR", :subunit             => "", :subunit_to_unit     => 1000000000000, :decimal_mark        => ".", :thousands_separator => ""})
#

unless Object.const_defined?('XMR')

  class XMR
    def self.new(amount); Money.new(amount, :xmr); end
    def to_s; Money.new(amount, :xmr).format.to_s; end
  end

end
