require "spec_helper"

RSpec.describe MoneroRPC do
  it "has a version number" do
    expect(MoneroRPC::VERSION).not_to be nil
  end

  it "gets the current address" do
    address = MoneroRPC::Wallet.address
    expect(address.length).to be 95
  end

  it "creates a new subaddress with a label" do
    subaddress = MoneroRPC::Wallet.create_address "wallet1"
    expect(subaddress['address'].length).to be 95
    expect(subaddress['address_index']).to be_truthy
  end

  it "creates an integrated address for a payment" do
    address = MoneroRPC::Wallet.make_integrated_address
    payment_id = address['payment_id']
    expect(address['integrated_address'].length).to be 106
    expect(payment_id.length).to be 16
  end

  it "lists all addresses of the wallet" do
    addresses = MoneroRPC::Wallet.get_addresses
    addresses.each do |adr|
      expect(adr['address']).to be_a(String)
      expect(adr['address'].length).to be 95
      expect(adr['address_index']).to be_an(Integer)
      expect(adr['label']).to be_a(String)
      expect(adr['used']).to be(true).or(be(false))
    end
  end

  it "gets the balance of the current wallet" do
    balance = MoneroRPC::Wallet.balance
    expect(balance).to be_a(Money)
    expect(balance.fractional).to be_an(Integer)
    expect(balance.currency).to be_a(Money::Currency)
  end

  it "returns a formatted balance with dot as decimal separator" do
    balance = MoneroRPC::Wallet.balance.format
    expect(balance).to be_a(String)
    expect(balance).to include('.')
  end

  it "gets the unlocked balance" do
    balance = MoneroRPC::Wallet.unlocked_balance
    expect(balance).to be_a(Money)
    expect(balance.fractional).to be_an(Integer)
    expect(balance.currency).to be_a(Money::Currency)
  end

  it "gets the balance and unlocked balance" do
    balance = MoneroRPC::Wallet.getbalance
    expect(balance['balance']).to be_an(Integer)
    expect(balance['unlocked_balance']).to be_an(Integer)
  end

  it "gets the current block height" do
    height = MoneroRPC::Wallet.getheight
    expect(height).to be_an(Integer)
  end

  # the wallet locks for approx 10 blocks so this test will fail if
  # balance is not yet unlocked
  it "sends XMR to a standard address" do
    subaddress = MoneroRPC::Wallet.create_address "receiving_wallet"
    amount = 20075
    transfer = MoneroRPC::Transfer.create(subaddress['address'], amount)
    expect(transfer['amount']).to eq(amount)
    expect(transfer['fee']).to be_an(Integer)
    expect(transfer['multisig_txset']).to be_empty
    expect(transfer['tx_blob']).to be_empty
    expect(transfer['tx_hash']).to be_truthy
    expect(transfer['tx_key']).to be_truthy
    expect(transfer['tx_metadata']).to be_empty
    expect(transfer['unsigned_txset']).to be_empty
  end

  it "sends XMR to multiple recipients" do
    subaddress1 = MoneroRPC::Wallet.create_address "receiving_wallet"
    subaddress2 = MoneroRPC::Wallet.create_address "receiving_wallet2"
    amount1 = 20075
    amount2 = 30075

    recipients = [
      { address: subaddress1['address'], amount: amount1 },
      { address: subaddress2['address'], amount: amount2 }
    ]

    transfer = MoneroRPC::Transfer.send_bulk(recipients)

    expect(transfer['amount']).to eq(amount1+amount2)
    expect(transfer['fee']).to be_an(Integer)
    expect(transfer['multisig_txset']).to be_empty
    expect(transfer['tx_blob']).to be_empty
    expect(transfer['tx_hash']).to be_truthy
    expect(transfer['tx_key']).to be_truthy
    expect(transfer['tx_metadata']).to be_empty
    expect(transfer['unsigned_txset']).to be_empty
  end

end
