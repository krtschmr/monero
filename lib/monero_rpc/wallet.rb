module MoneroRPC::Wallet

  def create_address(label="")
    request("create_address", label: label)
  end

  def get_address
    get_addresses(0, [0]).first["address"]
  end
  alias_method :address, :get_address

  def get_addresses(account_index=0, address_index=[0])
    request("get_address", {account_index: account_index, address_index: address_index})["addresses"]
  end

  def valid_address?(address)
    begin
      request("validate_address", {address: address}).fetch("valid")
    rescue
      false
    end
  end

  def getbalance
    request("getbalance")
  end

  def balance
    XMR.new(getbalance["balance"])
  end

  def unlocked_balance
    XMR.new(getbalance["unlocked_balance"])
  end

  def getaddress
    request("getaddress")["address"]
  end

  def getheight
    request("getheight")["height"]
  end

  def query_key(type)
    raise ArgumentError unless ["mnemonic", "view_key"].include?(type.to_s)
    request("query_key", {key_type: type})["key"]
  end
  def view_key; query_key(:view_key); end
  def mnemonic_seed; query_key(:mnemonic); end


  def make_integrated_address(payment_id = "")
    # TODO
    # Check if payment_id is correct format
    request("make_integrated_address", {payment_id: payment_id})
  end

  def split_integrated_address(address)
    request("split_integrated_address", {integrated_address: address})
  end

  def incoming_transfers(type)
    raise ArgumentError unless ["all", "available", "unavailable"].include?(type.to_s)
    json = request("incoming_transfers", {transfer_type: type})
    json["transfers"] || []
  end

  def get_payments(payment_id)
    payments = request("get_payments", {payment_id: payment_id})["payments"] || []
    # TODO
    # make it a MoneroRPC::Payment that hase a amount as XMR and confirmations (getheight - tx.block_height)
    payments.map{|x| Payment.from_raw(x) }
  end

  def get_bulk_payments(payment_ids, min_block_height)
    payments = request("get_bulk_payments", {"payment_ids": payment_ids, "min_block_height": min_block_height})
    return payments
  end


    # in - boolean;
    # out - boolean;
    # pending - boolean;
    # failed - boolean;
    # pool - boolean;
    # filter_by_height - boolean;
    # min_height - unsigned int;
    # max_height - unsigned int;
  def get_transfers(args={})
    f_in = args.fetch(:in, true)
    out = args.fetch(:out, false)
    pending = args.fetch(:pending, true)
    failed = args.fetch(:failed, false)
    pool = args.fetch(:pool, true)
    filter_by_height = args.fetch(:filter_by_height, false)
    min_height = args.fetch(:min_height, 0)
    max_height = args.fetch(:max_height, 0)

    options = {in: f_in, out: out, pending: pending, failed: failed, pool: pool, filter_by_height: filter_by_height, min_height: min_height}
    options[:max_height] = max_height if max_height > min_height

    h = Hash.new
    json = request("get_transfers", options)
    json.map{|k, v|
      h[k] = v.collect{|transfer|
        if k == "in"
          in_transfer_clazz.constantize.new(transfer)
        else
          out_transfer_clazz.constantize.new(transfer)
        end
      }
    }
    return h
  end

  def get_all_incoming_transfers(args={})
    pending = args.fetch(:pending, true)
    min_height = args.fetch(:min_height, 0)
    max_height = args.fetch(:max_height, 0)

    all = get_transfers(filter_by_height: true, min_height: min_height, max_height: max_height, in: true, out: false, pending: true, pool: true)
    [ all["in"], all["pending"], all["pool"]].flatten.compact
  end

  def get_all_outgoing_transfers(args={})
    pending = args.fetch(:pending, true)
    min_height = args.fetch(:min_height, 0)
    max_height = args.fetch(:max_height, 0)

    all = get_transfers(filter_by_height: true, min_height: min_height, max_height: max_height, in: false, out: true, pending: pending, pool: true)
    [ all["out"], all["pending"], all["pool"]].flatten.compact
  end

  def get_transfer_by_txid(txid)
    request("get_transfer_by_txid", {txid: txid })
  end

  # creates a wallet and uses it
  # if wallet exists, will automatically uses it!
  def create_wallet(filename, password, language="English")
    # TODO
    # language correct format?
    options = { filename: filename, password: password, language: language }
    !! request("create_wallet", options)
  end
  alias_method :create, :create_wallet

  # returns current balance if open successfull
  def open_wallet(filename, password="")
    options = { filename: filename, password: password}
    if request("open_wallet", options)
      balance
    else
      false
    end
  end
  alias_method :open, :open_wallet

  # stops current MoneroRPC process!
  def stop_wallet
    close!
  end
  alias_method :close, :stop_wallet

end
