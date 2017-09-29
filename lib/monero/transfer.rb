# transfer
# Send monero to a number of recipients.
# Inputs:
# destinations - array of destinations to receive XMR:
# amount - unsigned int; Amount to send to each destination, in atomic units.
# address - string; Destination public address.

# fee - unsigned int; Ignored, will be automatically calculated.

# mixin - unsigned int; Number of outpouts from the blockchain to mix with (0 means no mixing).

# unlock_time - unsigned int; Number of blocks before the monero can be spent (0 to not add a lock).

# payment_id - string; (Optional) Random 32-byte/64-character hex string to identify a transaction.

# get_tx_key - boolean; (Optional) Return the transaction key after sending.

# priority - unsigned int; Set a priority for the transaction. Accepted Values are: 0-3 for: default, unimportant, normal, elevated, priority.

# do_not_relay - boolean; (Optional) If true, the newly created transaction will not be relayed to the monero network. (Defaults to false)

# get_tx_hex - boolean; Return the transaction as hex string after sending


module Monero
  # => {"integrated_address"=>"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfwGRvbCHYCZAaKSzDx", "payment_id"=>"c7e7146b3335aa54"}

  class Transfer

    def self.create(address, amount, args={})
      send_bulk([address: address, amount: amount], args)
    end

    def self.send_bulk(destinations, args={})

      mixin = args.fetch(:mixin, 4)
      fee = args.fetch(:fee, 1) # ignored anyways
      unlock_time = args.fetch(:unlock_time, 0)
      payment_id = args.fetch(:payment_id, nil)
      get_tx_key = args.fetch(:get_tx_key, true)
      priority = args.fetch(:priority, 0)
      do_not_relay = args.fetch(:do_not_relay, false)
      get_tx_hex = args.fetch(:get_tx_hex, false)


      options = {
        destinations: destinations, fee: fee, mixin: mixin, unlock_time: unlock_time, 
        payment_id: payment_id, get_tx_key: get_tx_key, priority: priority, do_not_relay: do_not_relay, get_tx_hex: get_tx_hex
      }

      Monero::Client.request("transfer", options)
    end

  end
end
