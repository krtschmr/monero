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

Start your RPC Client `./monero-wallet-rpc --testnet  --rpc-bind-port 18081 --rpc-bind-ip 127.0.0.1  --rpc-login username:password --log-level 4 --wallet-dir ./`

- To open a wallet at start use `--wallet-file filename` and `--password pass`
- In case you need to access the client from another machine, you need to set `--confirm-external-bind`.
- To be able to create/open other wallets you need to specify `--wallet-file /path/to/wallets/on/your/machine`
- if you don't specify `--rpc-login` a file will be created that stores the login data (`cat monero-wallet-rpc.18081.login`)

## Getting started

### Configuration
    Monero.config.host = "127.0.0.1"
    Monero.config.port = "18081"
    Monero.config.username = "username"
    Monero.config.password = "password"



### Usage

Monero Ruby Client is very easy to use. Full documentation of RPC Client: https://getmonero.org/resources/developer-guides/wallet-rpc.html#transfer

___


Get the current address

    Monero::Wallet.address
	=> "9wm6oNA5nP3LnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjTDpKXAE"
___

Create a new address for a payment (integrated address)

	Monero::Wallet.make_integrated_address
	=> {"integrated_address"=>"A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfufSYUchQ8hH2R272H",
 	"payment_id"=>"9d985c985ce58a8e"}
___
To get the balance of the current wallet (we use the gem 'money')

    Monero::Wallet.balance
    # returns an ::XMR object which is just a shortcut for ::Money(amount, :xmr)
    => #<Money fractional:9980629640000 currency:XMR>

    Monero::Wallet.balance.format
    => "9.980629640000 XMR"

___
To get the current block height

    Monero::Wallet.getheight
    => 1008032


___

Send XMR to an address via `Monero::Transfer.create`. If successfull you will get the transaction  details. If not succesfull you'll get returned nil.

    amount= 20075 #in atomic units. 1000000000000 == 1.0 XMR    
    Monero::Transfer.create("A7TmpAyaPeZLnugTKRSwGJhW4vnYv8RAVdRvYyvbistbHUnojyTHyHcYpbZvbTZHDsi4rF1EK5TiYgnCN6FWM9HjfwGRvbCHYCZAaKSzDx", amount)
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

    Monero::Transfer.send_bulk(recipients, options)

___


## Donations
If this was useful you might consider a small donation:

- XMR: 4H19KAdSw1pL2v1iaEx31ngQCQcEGobUpevqtzSzKPTAEAt1Ay7NZrQgU6mnN2mVyWi7yk2ig68KsU8bfXQ45ainLTZFWU7m94yT3D9qUX
- BTC:
- LTC:




## LICENSE
MIT
