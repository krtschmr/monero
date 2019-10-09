class MoneroRPC::Client
  include MoneroRPC::Wallet
  include MoneroRPC::Transfer




  attr_reader :host, :port, :username, :password, :debug, :in_transfer_clazz, :out_transfer_clazz

  def initialize(args= {})
    @host     = args.fetch(:host,     MoneroRPC.config.host)
    @port     = args.fetch(:port,     MoneroRPC.config.port)
    @username = args.fetch(:username, MoneroRPC.config.username)
    @password = args.fetch(:password, MoneroRPC.config.password)
    @debug    = args.fetch(:debug,    MoneroRPC.config.debug)
    @in_transfer_clazz = args.fetch(:in_transfer_clazz, MoneroRPC.config.in_transfer_clazz || "MoneroRPC::IncomingTransfer")
    @out_transfer_clazz = args.fetch(:out_transfer_clazz, MoneroRPC.config.out_transfer_clazz || "MoneroRPC::OutgoingTransfer")
  end

  def close!
    request("stop_wallet")
  end

  def request(method, params="")
    # TODO
    # who can implement digest auth with net/http?
    # this is really ugly!
    data = '{"jsonrpc":"2.0","id":"0","method": "'+method+'", "params": '+params.to_json+' }'
    args = ""
    args << " -s"
    args << " -u #{username}:#{password} --digest"
    args << " -X POST #{base_uri}/json_rpc"
    args << " -d '#{data}'"
    args << " -H 'Content-Type: application/json'"

    p "curl #{args}" if debug
    begin
      json = JSON.parse(`curl #{args}`)
    rescue
      raise MoneroRPC::ConnectionError
    end

    # Error handling
    if json["error"]
      raise "#{json["error"]["message"]} | code: #{json["error"]["code"]}"
    end
    json["result"]
  end

  private

  def base_uri
    URI.parse("http://#{host}:#{port}")
  end

end
