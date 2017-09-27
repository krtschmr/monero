module Monero
  class Client

    def self.request(method, params=nil)
      params_string = ""
      if params
        # TODO multi params looping
        k,v = params.first
        params_string = '"'+k.to_s+'": "'+v.to_s+'"'
      end

      data = '{"jsonrpc":"2.0","id":"0","method": "'+method+'", "params": { '+params_string+' } }'
      args = " -s"
      args << " -u #{Monero.config.username}:#{Monero.config.password} --digest"
      args << " -X POST #{base_uri}/json_rpc"
      args << " -d '#{data}'"
      args << " -H 'Content-Type: application/json'"
      json = JSON.parse(`curl #{args}`)
      json["result"]
    end

    private

    def self.base_uri
      "http://#{Monero.config.host}:#{Monero.config.port}"
    end

  end
  
end
