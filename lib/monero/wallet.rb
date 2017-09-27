module Monero

  class Wallet

    def self.getaddress
      Monero::Client.request("getaddress")["address"]
    end
    def self.address; getaddress; end

    def self.getbalance
      Monero::Client.request("getbalance")
    end

    def self.balance
      XMR.new(getbalance["balance"])
    end

    def self.unlocked_balance
      XMR.new(getbalance["unlocked_balance"])
    end

    def self.getaddress
      Monero::Client.request("getaddress")["address"]
    end

    def self.getheight
      Monero::Client.request("getheight")["height"]
    end

    def self.query_key(type)
      raise ArgumentError unless ["mnemonic", "view_key"].include?(type.to_s)
      Monero::Client.request("query_key", {key_type: type})["key"]
    end

    def self.make_integrated_address(payment_id = "")
      # TODO
      # Check if payment_id is correct format
      Monero::Client.request("make_integrated_address", {payment_id: payment_id})
    end

    def self.incoming_transfers(type)
      raise ArgumentError unless ["all", "available", "unavailable"].include?(type.to_s)
      json = Monero::Client.request("incoming_transfers", {transfer_type: type})
      json["transfers"] || []
    end

    def self.get_payments(payment_id)
      payments = Monero::Client.request("get_payments", {payment_id: payment_id})["payments"] || []
      # TODO
      # make it a Monero::Payment that hase a amount as XMR and confirmations (getheight - tx.block_height)
      payments.map{|x| Payment.from_raw(x) }
    end

    def self.get_transfer_by_txid(txid)
      Monero::Client.request("get_transfer_by_txid", {txid: txid })
    end

  end

end
