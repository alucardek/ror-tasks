require 'rspec'
require_relative 'virtual_wallet_test_helper'
require_relative '../specs/spec_helper'
require_relative '../../app/models/virtual_wallet'
require_relative '../../app/models/bank'
require_relative '../../app/models/account'
require_relative '../../app/exceptions/exceptions'


describe "virtual wallet" do
  include VirtualWalletTestHelper

  specify "send request to users bank to supply arbitrary amount of money in any of the definied currencies" do
    set_balance :pln => 200
    set_bank_accounts :pko => "22 2222 2222 2222 2222 2222 2222"
    transfer_up(:pln, :pko, 300)
    get_balance(:eur).should == 200
    get_balance(:pln).should == 600
  end

  specify "convert some money from one currency to another according to a currency exchange table" do
    set_balance :eur => 200, :pln => 600
    set_exchange_rate [:eur,:pln] => 4.15
    convert_money(:pln, :eur, 100)
    get_balance(:eur).should == 200 + 100/4.15
    get_balance(:pln).should == 500
  end

  specify "buy stocks according to stock exchange rates" do
    set_balance :eur => 200, :pln => 600
    set_stock_exchang_rate :PGE => 17.59, :ATLANTIS => 0.11
    set_stocks :PGE => 0, :ATLANTIS => 20
    buy_stocks(:pln, :PGE, 5)
    get_stocks(:PGE).should == 5
    get_stocks(:ATLANTIS).should == 20
    get_balance(:eur).should == 200
    get_balance(:pln).should == 600 - 5*17.59
  end

  specify "sell some stocks according to stock exchange rates" do
    set_balance :eur => 200, :pln => 600
    set_stock_exchang_rate :PGE => 17.59, :ATLANTIS => 0.11
    set_stocks :PGE => 0, :ATLANTIS => 20
    sell_stocks(:pln, :ATLANTIS, 15)
    get_stocks(:PGE).should == 0
    get_stocks(:ATLANTIS).should == 5
    get_balance(:eur).should == 200
    get_balance(:pln).should == 600 + 15*0.11
  end


  specify "transfer back money to users bank account" do
    set_balance :eur => 200, :pln => 600
    set_bank_accounts :mbank => "11 1111 1111 1111 1111 1111 1111", :pko => "22 2222 2222 2222 2222 2222 2222"
    transfer_back_money(50, :eur, :mbank)
    get_balance(:eur).should == 150
    get_balance(:pln).should == 600
    get_bank_accounts(:mbank).should == "11 1111 1111 1111 1111 1111 1111"
    get_bank_accounts(:pko).should == "22 2222 2222 2222 2222 2222 2222"
  end

end