module MoneroRPC
  class TransferClass

    attr_accessor :address, :amount, :double_spend_seen, :fee, :height, :note,
      :payment_id, :subaddr_index, :timestamp, :txid, :type, :unlock_time,
      :destinations, :confirmations, :suggested_confirmations_threshold, :subaddr_indices

    def initialize(args={})
      args.each do |k,v|
        self.send("#{k}=", v)
      end
    end

    def confirmed?
      confirmations >= 10
    end

    def pending?
      height == 0
    end

    def locked?
      raise "TODO"
    end

  end
end

class MoneroRPC::IncomingTransfer < MoneroRPC::TransferClass; end
class MoneroRPC::OutgoingTransfer < MoneroRPC::TransferClass; end
