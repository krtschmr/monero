module Monero
  class Client

    def self.close!
      request("stop_wallet")
    end

    def self.request(method, params="")
      data = '{"jsonrpc":"2.0","id":"0","method": "'+method+'", "params": '+params.to_json+' }'

      args = " -s"
      args << " -u #{Monero.config.username}:#{Monero.config.password} --digest"
      args << " -X POST #{base_uri}/json_rpc"
      args << " -d '#{data}'"
      args << " -H 'Content-Type: application/json'"

      p "curl #{args}" if Monero.config.debug

      json = JSON.parse(`curl #{args}`)
      json["result"]
    end

    private

    def self.base_uri
      "http://#{Monero.config.host}:#{Monero.config.port}"
    end

  end

end
