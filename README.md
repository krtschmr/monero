*Heavy development. Tested against 0.13.0 without issues. Please contribute. If you want to send Testnet transactions, please always send them back to https://dis.gratis*

# Monero Ruby Client

Ruby client to connect and use [Monero Wallet RPC](https://getmonero.org/resources/developer-guides/wallet-rpc.html).


___
#### Disclaimer - before you start - *important notice!*
To try out please make sure that you run your **monerod** and your **monero-wallet-rpc** with the `--testnet` option. Always use the Testchain to play around. Be careful with your wallet, you might lose coins if you try out on the real chain.

- Testnet Faucet: https://dis.gratis/
- Testnet Blockexplorer: https://testnet.xmrchain.com
---




## Installation
For easy installation add `gem 'monero'` to your Gemfile or run `gem install monero`


## Preparation

Start your daemon `./monerod --testnet`

Start your RPC Client `./monero-wallet-rpc --testnet  --rpc-bind-port 18081 --rpc-bind-ip 127.0.0.1  --rpc-login username:password --log-level 4`

- To open a wallet at start use `--wallet-file filename` and `--password pass`
- In case you need to access the client from another machine, you need to set `--confirm-external-bind`.
- To be able to create/open other wallets you need to specify `--wallet-file /path/to/wallets/on/your/machine`
- if you don't specify `--rpc-login` a file will be created that stores the login data (`cat monero-wallet-rpc.18081.login`)

## Getting started

### Configuration
    RPC.config.host = "127.0.0.1"
    RPC.config.port = "18081"
    RPC.config.username = "username"
    RPC.config.password = "password"
    RPC.config.transfer_clazz = "MoneroTransfer" # you can set your own class to get incoming transfers as a model rather then a json


### Usage

Monero Ruby Client is very easy to use. Full documentation of RPC Client: https://getmonero.org/resources/developer-guides/wallet-rpc.html#transfer

___


Get the current address

    RPC::Wallet.address
	=> "9wm6oNA5nP3LnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjTDpKXAE"

___

Create a new Subaddress with a label

    RPC::Wallet.create_address "family savings"
    => {"address"=>"BZFWM5MrhK64DD5TH1JVxR4JbuQpmRSFKi4SHQD2TrSrDFU8AK16YSjN7K8WSfjAfnZeJeskBtkgr73LbPZc4vMbQr3YvHj", "address_index"=>1}

___

Create a new address for a payment (integrated address)

	RPC::Wallet.make_integrated_address
	=> {"integrated_address"=>"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfufSYUchQ8hH2R272H",
 	"payment_id"=>"9d985c985ce58a8e"}
  ___

Get a list of all Adresses of your wallet

    RPC::Wallet.get_addresses

___


To get the balance of the current wallet (we use the gem 'money')

    RPC::Wallet.balance
    # returns an ::XMR object which is just a shortcut for ::Money(amount, :xmr)
    => #<Money fractional:9980629640000 currency:XMR>

    RPC::Wallet.balance.format
    => "9.980629640000 XMR"

To get the unlocked balance, which is currently available

    RPC::Wallet.unlocked_balance
    => #<Money fractional:10000 currency:XMR>

To get both combined

    RPC::Wallet.getbalance
    => {"balance"=>9961213880000, "unlocked_balance"=>10000}



___
To get the current block height

    RPC::Wallet.getheight
    => 1008032


___

Send XMR to an address via `RPC::Transfer.create`. If successfull you will get the transaction  details. If not succesfull you'll get returned nil.

    amount= 20075 #in atomic units. 1000000000000 == 1.0 XMR    
    RPC::Transfer.create("A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfwGRvbCHYCZAaKSzDx", amount)
	=> {"fee"=>19415760000,
 		"tx_blob"=>"020001020005bbcf0896e3.......


To send payments you can also specify the following options:

    options = { fee: fee, mixin: 5, unlock_time: unlock_time, payment_id: "c7e7146b3335aa54", get_tx_key: true, priority: 0, do_not_relay: false, get_tx_hex: true}
Please note that `fee` is currently ignored by the chain.


To send payments to multiple recipients simply use an array of `[:recipient, :amount]`. For example:

    recipients = [
    	{address:A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfwGRvbCHYCZAaKSzDx amount: 1599999},
    	{address:A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9Hjftr1RgJ6RM4BMMPLUc amount: 130000},
    	{address:A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfrgPgAEasYGSVhUdwe amount: 442130000}
    ]

    RPC::Transfer.send_bulk(recipients, options)

___


To get a list of transfers you call `get_transfers(args)`. Options are `in (true)`, `out (false)`, `pending (true)`, `failed (false)`, `pool (true)`, `filter_by_height (false)`, `min_height` and `max_height`

___

To get all incoming transfers use `get_all_incoming_transfers(args)`. Args can be `min_height` and `max_height` to filter accordingly. Result is a list of `RPC::IncomingTransfer` objects.

    incomes = RPC::Wallet.get_all_incoming_transfers(min_height: 1087400)
    => [#<RPC::IncomingTransfer:0x000000036d3ca8 ...>, #<RPC::IncomingTransfer:0x000000036d38c0 ...>, #<RPC::IncomingTransfer:0x000000036d3258 ...>, #<RPC::IncomingTransfer:0x000000036d2c90 ...> ....

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

You can use your own custom class by using the config `RPC.config.transfer_clazz = "MyCustomMoneroTransfer"`

___

For a specific Transfer simply call `get_transfer_by_txid(tx_id)`

___



## Donations
If this was useful you might consider a small donation:

- XMR: 42gYBRdXZbDdpV8gn7ntZySQuY4kzF7upNw67cj1LkkxV3kgjqoBBU9fBPeh4mZMMb75WAkNisvKdehdiE3g7Awx3JSdd5Y

Even better would be your contribution to the code. Let's work together and make this gem a great place for all Monero fans! Don't just fork and do your own thing. My idea for this gem isn't the way we have to do. Feel free to bring yourself into this project. I'm willing to change everything from scratch if it will benefit the future.


## LICENSE
MIT
