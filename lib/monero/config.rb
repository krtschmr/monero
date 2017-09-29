require 'singleton'
module Monero
  class Config
    include Singleton
    attr_accessor :host, :port, :username, :password, :debug
  end
end
