module ExchangerTestHelper

  ##
  #def find_account(currency)
  #  @accounts.find{|a| a.currency == currency }
  #end
  #
  #def find_rate(from_currency,to_currency)
  #  @rates.find{|r| r.from_currency == from_currency &&
  #      r.to_currency == to_currency}
  #end
  #
  #def find_stock_rate(name)
  #  @stock_rates.find{|sr| sr.name == name }
  #end
  #
  #def find_stock(name)
  #  @stocks.find{|s| s.name == name }
  #end
  #
  #def find_bank(name)
  #  @banks.find{|b| b.name == name }
  #end
  #

  def set_balance(accounts)
    @accounts ||= []
    accounts.each do |account|
      @accounts << Account.new(account)
    end
  end

  def set_bank_accounts(banks)
    @banks ||= []
    banks.each do |bank|
      @banks << Bank.new(bank)
    end
  end

  def set_stocks(stocks)
    @stocks ||=[]
    stocks.each do |name,rate|
      @stocks << Stock.new(name,rate)
    end
  end

  def get_balance(currency)
    find(:account, currency).money
  end

  def get_bank_accounts(name)
    find_bank(name).account_number
  end

  def get_stocks(name)
    find_stock(name).balance
  end




  def transfer_up_money(amount, currency, bank)
    @banks ||= []

    if @banks.find(bank) == false
      @banks << Bank.new (bank)
    end

    #if @banks.find(bank).get(amount)
     # find_account(currency).add_money(amount)
    #end
    bank_transferer = BankTransferer.new(find_account(currency), find_banks(bank))
    bank_transferer.get_money(amount)
  end

  def transfer_back_money(amount, currency, bank)
    bank_transferer = BankTransferer.new(find_account(currency), find_banks(bank))
    bank_transferer.give_back_money(amount)
  end



  def set_exchange_rate(rates)
    rates.each do |(from_currency,to_currency),rate|
      if find_rate(from_currency,to_currency)
        find_rate(from_currency,to_currency).set_rate(rate)
      else
        @rates ||= []
        @rates << ExchangeRate.new(from_currency,to_currency,rate)
      end
    end
  end

  def set_stock_exchange_rate(stock_rates)
    stock_rates.each do |name, rate|
      if find_stock(name)
        find_stock(name).set_rate(rate)
      else
        @stock_rates ||= []
        @stock_rates << StockExchangeRate.new(name,rate)
      end
    end
  end

  def convert_money(from_currency,to_currency,limit)
    exchanger = Exchanger.new(find_account(from_currency),find_account(to_currency),
                              find_rate(from_currency,to_currency))
    exchanger.convert(limit)
  end


  def buy_stocks(currency, stock_name, amount)
    @stocks ||= []
    @stocks << Stock.new(stock_name, 0) unless stock_find(stock_name)

    stock_transactioner = StockTransactioner.new(find_account(currency), find_stock(stock_name))
    stock_transactioner.buy(amount)
  end

  def sell_stocks(currency, stock_name, amount)
    stock_transactioner = StockTransactioner.new(find_account(currency), find_stock(stock_name))
    stock_transactioner.sell(amount)
  end

end
