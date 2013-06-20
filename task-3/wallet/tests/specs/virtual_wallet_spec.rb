require 'rspec'
require_relative 'spec_helper'
require_relative '../../app/models/virtual_wallet'
require_relative '../../app/models/account'
require_relative '../../app/models/bank'
require_relative '../../app/exceptions/exceptions'

describe "VirtualWallet" do
  subject(:wallet)       { VirtualWallet.new(v_accounts: accounts) }
  let(:accounts)                  { [:pln=>0] }
  let(:banks)                     { [] }
  let(:stocks)                    { [] }
  let(:rates)                     { [] }
  let(:stock_rates)               { [] }

  context "with one account" do

    context "at start" do
      it "should raise an exception when nil is passed to the constructor" do
        expect { VirtualWallet.new(v_accounts: nil) }.to raise_error(IllegalArgument)
      end

      it "should have only one currency account" do
        wallet.accounts.size.should == 1
      end

      it "should find account by currency" do
        wallet.find(:account,:pln).display.should == "0 PLN"
      end

      it "should raise an exception when currency cannot be found" do
        expect { wallet.find(:account,:chr) }.to raise_error(NonExistingObject)
      end

      it "should have empty banks" do
        wallet.banks.should be_empty
      end

      it "should have empty stocks" do
        wallet.stocks.should be_empty
      end

      it "should have empty rates" do
        wallet.rates.should be_empty
      end

      it "should have empty stock_rates" do
        wallet.stock_rates.should be_empty
      end

    end

    context "transfering money" do
      let(:bank_name)  {"mbank"}
      let(:account_number)   {"11 1111 1111 1111 1111 1111 1111"}
      let(:bank_name_2) {"pko"}
      let(:account_number_2) {"22 2222 2222 2222 2222 2222 2222"}

      context "while adding banks" do
        it "should accept a bank account" do
          wallet.add(:bank, bank_name => account_number)
          wallet.find(:bank_restrict, bank_name, account_number).display.should == "mbank: 11 1111 1111 1111 1111 1111 1111"
        end

        it "should raise exception if nil is passed as bank account" do
          expect { wallet.add(:bank,nil) }.to raise_error(IllegalArgument)
        end

        it "should raise exception if there bank number has no 32 signs" do
          expect { wallet.add(:bank,"mbank" => "0000") }.to raise_error(IllegalArgument)
        end

        it "should add more than one bank" do
          wallet.add(:bank, bank_name => account_number)
          wallet.add(:bank, bank_name_2 => account_number_2)
          wallet.banks.size.should == 2
          wallet.find(:bank_restrict, bank_name, account_number).display.should == "mbank: 11 1111 1111 1111 1111 1111 1111"
          wallet.find(:bank_restrict, bank_name_2, account_number_2).display.should == "pko: 22 2222 2222 2222 2222 2222 2222"
        end

        it "should add few banks with the same name" do
          wallet.add(:bank, bank_name => account_number)
          wallet.add(:bank, bank_name => account_number_2)
          wallet.banks.size.should == 2
        end

        it "should not add a new bank if there is such a bank in wallet" do
          wallet.add(:bank, bank_name => account_number)
          wallet.add(:bank, bank_name_2 => account_number_2)
          wallet.add(:bank, bank_name => account_number)
          wallet.banks.size.should == 2
        end

      end

      context "with 300 PLN" do
        subject(:wallet)       { VirtualWallet.new(v_accounts: accounts, v_external_bank: external_bank) }
        let(:account) {:pln}
        let(:money) {300}
        let(:external_bank)       { mock }

        it "should transfer up money from bank" do
          mock(external_bank).transfer_money_up(money, bank_name) {true}

          wallet.find(:account,:pln).display.should == "0 PLN"
          wallet.add(:bank, bank_name => account_number)
          wallet.transfer_up(account, bank_name, money)
          wallet.find(:account,:pln).display.should == "300 PLN"
        end

        it "should not add money to the wallet if transfer_up failed" do
          mock(external_bank).transfer_money_up(money, bank_name) {false}

          wallet.find(:account,:pln).display.should == "0 PLN"
          wallet.add(:bank, bank_name => account_number)
          wallet.transfer_up(account, bank_name, money)
          wallet.find(:account,:pln).display.should == "0 PLN"
        end

        it "should transfer back money to the bank" do
          mock(external_bank).transfer_money_up(money, bank_name) {true}
          mock(external_bank).transfer_money_back(account_number, bank_name, money) {true}

          wallet.add(:bank, bank_name => account_number)
          wallet.transfer_up(account, bank_name, money)
          wallet.find(:account,:pln).display.should == "300 PLN"
          wallet.transfer_back(account, bank_name, account_number, money)
          wallet.find(:account,:pln).display.should == "0 PLN"
        end

        it "should not remove money from wallet if transfer_back failed" do
          mock(external_bank).transfer_money_up(money, bank_name) {true}
          mock(external_bank).transfer_money_back(account_number, bank_name, money) {false}

          wallet.add(:bank, bank_name => account_number)
          wallet.transfer_up(account, bank_name, money)
          wallet.find(:account,:pln).display.should == "300 PLN"
          wallet.transfer_back(account, bank_name, account_number, money)
          wallet.find(:account,:pln).display.should == "300 PLN"
        end

      end

    end

    context "making stock market transactions" do
      subject(:wallet)       { VirtualWallet.new(v_accounts: accounts, v_external_bank: external_bank, v_external_stock_market: external_stock_market) }
      let(:external_bank)   { mock }
      let(:external_stock_market) {mock}
      let(:stock_market_rates_1)    {[:PGE => 17.59, :ATLANTIS => 0.11]}
      let(:stock_market_rates_2)    {[:PGE => 13.13, :ATLANTIS => 0.33]}

      context "by checking stock rates" do
        it "should check stock_market rates" do
          mock(external_stock_market).check_externally(:stock_rates) { stock_market_rates_1 }

          wallet.check(:stock_rates).should == "[{:PGE=>17.59, :ATLANTIS=>0.11}]"
        end

        it "should update stock_market rates" do

        end

      end

      context "by buying" do
        it "should allow to buy stock if have enough money" do

        end

        it "should not allow to boy stocks if you have not enough money" do

        end

        it "should not add stocks to the wallet if there is no confirmation from stock market of purchase" do

        end

        it "should display available stocks" do

        end
      end

      context "by selling" do
        it "should allow to compare stock rates: actual and from buying moment" do

        end

        it "should allow to sell stocks" do

        end

        it "should not allow to sell more stocks than you possess" do

        end

        it "should not allow to remove stocks from wallet if there is no confirmation from stock market of selling" do

        end

      end
    end

  end

end
