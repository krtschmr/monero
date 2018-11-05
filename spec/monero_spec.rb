require "spec_helper"

RSpec.describe RPC do
  it "has a version number" do
    expect(RPC::VERSION).not_to be nil
  end

  it "gets the current address" do
    address = RPC::Wallet.address
    expect(address.length).to be 95
  end

  it "creates a new subaddress with a label" do
    subaddress = RPC::Wallet.create_address "wallet1"
    expect(subaddress['address'].length).to be 95
    expect(subaddress['address_index']).to be_truthy
  end

  it "creates an integrated address for a payment" do
    address = RPC::Wallet.make_integrated_address
    payment_id = address['payment_id']
    expect(address['integrated_address'].length).to be 106
    expect(payment_id.length).to be 16
  end

  it "lists all addresses of the wallet" do
    addresses = RPC::Wallet.get_addresses
    addresses.each do |adr|
      expect(adr['address']).to be_a(String)
      expect(adr['address'].length).to be 95
      expect(adr['address_index']).to be_an(Integer)
      expect(adr['label']).to be_a(String)
      expect(adr['used']).to be(true).or(be(false))
    end
  end

  it "gets the balance of the current wallet" do
    balance = RPC::Wallet.balance
    expect(balance).to be_a(Money)
    expect(balance.fractional).to be_an(Integer)
    expect(balance.currency).to be_a(Money::Currency)
  end

  it "returns a formatted balance" do
    balance = RPC::Wallet.balance.format
    expect(balance).to be_a(String)
  end

  it "gets the unlocked balance" do
    balance = RPC::Wallet.unlocked_balance
    expect(balance).to be_a(Money)
    expect(balance.fractional).to be_an(Integer)
    expect(balance.currency).to be_a(Money::Currency)
  end

  it "gets the balance and unlocked balance" do
    balance = RPC::Wallet.getbalance
    expect(balance['balance']).to be_an(Integer)
    expect(balance['unlocked_balance']).to be_an(Integer)
  end

  it "gets the current block height" do
    height = RPC::Wallet.getheight
    expect(height).to be_an(Integer)
  end

  it "sends XMR to an address" do
    pending("Needs to be written")
    fail
  end

end
