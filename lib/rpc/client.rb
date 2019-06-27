module RPC
  class Client
    attr_reader :host, :port, :username, :password, :transfer_clazz, :rpc, :debug

    def initialize(host, port, username, password, transfer_clazz, rpc=false, debug=false)
      @host = host
      @port = port
      @username = username
      @password = password
      @transfer_clazz = transfer_clazz
      @rpc = rpc
      @debug = debug
    end

    def self.close!
      request("stop_wallet")
    end

    def self.request(method, params="")
      data = '{"jsonrpc":"2.0","id":"0","method": "'+method+'", "params": '+params.to_json+' }'

      args = ""
      args << " -s"
      if (rpc)
        args << " -u #{RPC.config.username}:#{RPC.config.password} --digest"
        args << " -X POST #{base_uri}/json_rpc"
      else
        args << " -u #{username}:#{password} --digest"
        args << " -X POST #{uri}/json_rpc"
      end
      args << " -d '#{data}'"
      args << " -H 'Content-Type: application/json'"

      p "curl #{args}" if debug or RPC.config.debug

      json = JSON.parse(`curl #{args}`)

      # Error handling
      if json["error"]
        raise "#{json["error"]["message"]} | code: #{json["error"]["code"]}"
      end

      json["result"]
    end

    def rpc
      @rpc || false
    end

    private

    def self.base_uri
      "http://#{RPC.config.host}:#{RPC.config.port}"
    end

    def self.uri
      "http://#{host}:#{port}"
    end

  end
end
