module RPC
  class IncomingTransfer

    attr_accessor :address, :amount, :double_spend_seen, :fee, :height, :note, :payment_id, :subaddr_index, :timestamp, :txid, :type, :unlock_time, :destinations, :confirmations, :suggested_confirmations_threshold

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

  end

end
