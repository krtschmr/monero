module RPC

  class Wallet

    def self.create_address(label="")
      RPC::Client.request("create_address", label: label)
    end

    def self.get_address
      RPC::Client.request("get_address")["address"]
    end
    def self.address; getaddress; end

    def self.get_addresses
      RPC::Client.request("get_address")["addresses"]
    end

    def self.getbalance
      RPC::Client.request("getbalance")
    end

    def self.balance
      XMR.new(getbalance["balance"])
    end

    def self.unlocked_balance
      XMR.new(getbalance["unlocked_balance"])
    end

    def self.getaddress
      RPC::Client.request("getaddress")["address"]
    end

    def self.getheight
      RPC::Client.request("getheight")["height"]
    end

    def self.query_key(type)
      raise ArgumentError unless ["mnemonic", "view_key"].include?(type.to_s)
      RPC::Client.request("query_key", {key_type: type})["key"]
    end
    def self.view_key; query_key(:view_key); end
    def self.mnemonic_seed; query_key(:mnemonic); end


    def self.make_integrated_address(payment_id = "")
      # TODO
      # Check if payment_id is correct format
      RPC::Client.request("make_integrated_address", {payment_id: payment_id})
    end

    def self.incoming_transfers(type)
      raise ArgumentError unless ["all", "available", "unavailable"].include?(type.to_s)
      json = RPC::Client.request("incoming_transfers", {transfer_type: type})
      json["transfers"] || []
    end

    def self.get_payments(payment_id)
      payments = RPC::Client.request("get_payments", {payment_id: payment_id})["payments"] || []
      # TODO
      # make it a RPC::Payment that hase a amount as XMR and confirmations (getheight - tx.block_height)
      payments.map{|x| Payment.from_raw(x) }
    end


      # in - boolean;
      # out - boolean;
      # pending - boolean;
      # failed - boolean;
      # pool - boolean;
      # filter_by_height - boolean;
      # min_height - unsigned int;
      # max_height - unsigned int;
    def self.get_transfers(args={})
      f_in = args.fetch(:in, true)
      out = args.fetch(:out, false)
      pending = args.fetch(:pending, true)
      failed = args.fetch(:failed, false)
      pool = args.fetch(:pool, true)
      filter_by_height = args.fetch(:filter_by_height, false)
      min_height = args.fetch(:min_height, 0)
      max_height = args.fetch(:max_height, 0)

      options = {in: f_in, out: out, pending: pending, failed: failed, pool: pool, filter_by_height: filter_by_height, min_height: min_height, max_height: max_height}

      RPC::Client.request("get_transfers", options)
    end

    def self.get_transfer_by_txid(txid)
      RPC::Client.request("get_transfer_by_txid", {txid: txid })
    end

    # creates a wallet and uses it
    # if wallet exists, will automatically uses it!
    def self.create_wallet(filename, password, language="English")
      # TODO
      # language correct format?
      options = { filename: filename, password: password, language: language }
      !! RPC::Client.request("create_wallet", options)
    end
    singleton_class.send(:alias_method, :create, :create_wallet)

    # returns current balance if open successfull
    def self.open_wallet(filename, password="")
      options = { filename: filename, password: password}
      if RPC::Client.request("open_wallet", options)
        balance
      else
        false
      end
    end
    singleton_class.send(:alias_method, :open, :open_wallet)

    # stops current RPC process!
    def self.stop_wallet
      RPC::Client.close!
    end
    singleton_class.send(:alias_method, :close, :stop_wallet)



  end

end
