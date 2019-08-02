attention: version 0.0.12 had critical changes to this gem that will break all previous functionality. please upgrade, changing your code is very easy!massive Refactoring


# Monero Ruby Client

Ruby client to connect and use [Monero Wallet RPC](https://getmonero.org/resources/developer-guides/wallet-rpc.html).

*Tested against [0.14.1.2 Boron Butterfly](https://web.getmonero.org/downloads/) without issues. Please contribute. If you want to send testnet transactions, please always send them back to https://dis.gratis or any other faucet*

---
#### Disclaimer - before you start - *important notice!*
To try out please make sure that you run your **monerod** and your **monero-wallet-rpc** with the `--stagenet` or `--testnet` option. Always use the stagenet or testnet to play around. Be careful with your wallet, you might lose coins if you try out on the real chain.

- Stagenet Faucet: https://community.xmr.to/faucet/stagenet/
- Testnet Faucet: https://dis.gratis/
- Testnet Blockexplorer: https://testnet.xmrchain.com
- in case the faucets are offline or empty just ask on reddit or in IRC #monero, #monero-dev or #monero-pools
---

## Installation
For easy installation add `gem 'monero'` to your Gemfile or run `gem install monero`

## Preparation
Start your daemon `./monerod --testnet` or `./monerod --stagenet`

Start your RPC Client `./monero-wallet-rpc --testnet  --rpc-bind-port 28081 --rpc-bind-ip 127.0.0.1  --rpc-login username:password --log-level 4`


- To open a wallet at start use `--wallet-file filename` and `--password pass`
- In case you need to access the client from another machine, you need to set `--confirm-external-bind`.
- To be able to create/open other wallets you need to specify `--wallet-file /path/to/wallets/on/your/machine`
- if you don't specify `--rpc-login` a file will be created that stores the login data (`cat monero-wallet-rpc.28081.login`)

You can also use
[monerod-rpc-docker](https://github.com/xaviablaza/monerod-rpc-docker) by
xaviablaza to run monerod and the RPC client.

## Getting started

### Configuration
You can predefine all variables via configuration. You don't need to do this.
```ruby

MoneroRPC.config.host = "127.0.0.1"
MoneroRPC.config.port = "18081"
MoneroRPC.config.username = "username"
MoneroRPC.config.password = "password"
MoneroRPC.config.debug = true
# If you call for transfers you already receive objects MoneroRPC::IncomingTransfer and MoneroRPC::OutgoingTransfer. However, you can use your own classes.
# MoneroRPC.config.in_transfer_clazz = "MyOwnClassForIncomingTransfers"
# MoneroRPC.config.out_transfer_clazz = "OutgoinMoneroTransfer"
```

### Usage

Monero Ruby Client is very easy to use. Full documentation of RPC Client: https://getmonero.org/resources/developer-guides/wallet-rpc.html#transfer

just crate a new instance
`$monero_rpc = MoneroRPC.new(host: "192.168.0.202", port: "28081", username: "username", password: "password")`

---
Get the current address
```ruby
$monero_rpc.address
=> "9wm6oNA5nP3LnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjTDpKXAE"
```

---
Create a new subaddress with a label (label is optional)
```ruby
$monero_rpc.create_address "family savings"
=> {"address"=>"BZFWM5MrhK64DD5TH1JVxR4JbuQpmRSFKi4SHQD2TrSrDFU8AK16YSjN7K8WSfjAfnZeJeskBtkgr73LbPZc4vMbQr3YvHj", "address_index"=>1}
```

---
Create a new address for a payment (integrated address)
```ruby
$monero_rpc.make_integrated_address
=> {"integrated_address"=>"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfufSYUchQ8hH2R272H",
    "payment_id"=>"9d985c985ce58a8e"}
```

---
Get a list of all addresses of your wallet
```ruby
$monero_rpc.get_addresses
```

---
To get the balance of the current wallet (we use the gem 'money')
```ruby
$monero_rpc.balance
# returns an ::XMR object which is just a shortcut for ::Money(amount, :xmr)
=> <Money fractional:9980629640000 currency:XMR>

$monero_rpc.balance.format
=> "9.980629640000 XMR"
```

To get the unlocked balance, which is currently available
```ruby
$monero_rpc.unlocked_balance
=> <Money fractional:10000 currency:XMR>
```

To get both combined
```ruby
$monero_rpc.getbalance
=> {"balance"=>9961213880000, "unlocked_balance"=>10000}
```

---
To get the current block height
```ruby
$monero_rpc.getheight
=> 1008032
```

---
Send XMR to an address via `$monero_rpc.create_transfer`. If successful you will get the transaction details. If not successful you'll get returned nil.

```ruby
amount= 20075 # in atomic units; 1000000000000 == 1.0 XMR
$monero_rpc.create_transfer("A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfwGRvbCHYCZAaKSzDx", amount)
=> {"fee"=>19415760000,
    "tx_blob"=>"020001020005bbcf0896e3.......
```

The return hash consists of:
```
{amount, fee, multisig_txset, tx_blog, tx_hash, tx_key, tx_metadata,
unsigned_txset}
```

To send payments you can also specify the following options:

```ruby
options = { fee: fee, mixin: 5, unlock_time: unlock_time, payment_id: "c7e7146b3335aa54", get_tx_key: true, priority: 0, do_not_relay: false, get_tx_hex: true}
```

Please note that `fee` is currently ignored by the chain.

To send payments to multiple recipients simply use an array of `[:recipient, :amount]`. For example:

```ruby
recipients = [
  {address:"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfwGRvbCHYCZAaKSzDx" amount: 1599999},
  {address:"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9Hjftr1RgJ6RM4BMMPLUc" amount: 130000},
  {address:"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfrgPgAEasYGSVhUdwe" amount: 442130000}
]

$monero_rpc.send_bulk_transfer(recipients, options)
```

---
To get a list of transfers you call `get_transfers(args)`. Options are `in (true)`, `out (false)`, `pending (true)`, `failed (false)`, `pool (true)`, `filter_by_height (false)`, `min_height` and `max_height`

---
To get all incoming transfers use `get_all_incoming_transfers(args)`. Args can be `min_height` and `max_height` to filter accordingly. Result is a list of `MoneroRPC::IncomingTransfer` objects.

```ruby
incomes = $monero_rpc.get_all_incoming_transfers(min_height: 1087400)
=> [#<MoneroRPC::IncomingTransfer:0x000000036d3ca8 ...>, #<MoneroRPC::IncomingTransfer:0x000000036d38c0 ...>, #<MoneroRPC::IncomingTransfer:0x000000036d3258 ...>, #<MoneroRPC::IncomingTransfer:0x000000036d2c90 ...> ....

incomes.first.confirmed?
=> false

incomes.first.pending?
=> true

incomes.first.confirmations?
=> 0

incomes.first.address
=> "9vN5sHeH2a6AbRsB1dZ3APavL3YyFLguhh5pu2cAHb4CTY9GtnsEsBYTzwxzL6XH4Uby2Svju8sYvZN7mDMcd6MTKDvBgVR"

incomes.first.amount
=> 0.40123
```

You can use your own custom class by using the config `MoneroRPC.config.in_transfer_clazz = "MyCustomMoneroTransfer"`

The same works for outgoing transfers where we have "MoneroRPC::OutgoingTransfer"

    $monero_rpc.get_all_outgoing_transfers


---
For a specific Transfer simply call `$monero_rpc.get_transfer_by_txid(tx_id)`

---
## Running tests

Configure the RPC singleton in
[spec_helper.rb](https://github.com/krtschmr/monero/blob/master/spec/spec_helper.rb)

## Donations
If this was useful you might consider a small donation:

krtschmr:
```
42gYBRdXZbDdpV8gn7ntZySQuY4kzF7upNw67cj1LkkxV3kgjqoBBU9fBPeh4mZMMb75WAkNisvKdehdiE3g7Awx3JSdd5Y
```

Even better would be your contribution to the code. Let's work together and make this gem a great place for all Monero fans! Don't just fork and do your own thing. My idea for this gem isn't the way we have to do. Feel free to bring yourself into this project. I'm willing to change everything from scratch if it will benefit the future.

## License
This gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
