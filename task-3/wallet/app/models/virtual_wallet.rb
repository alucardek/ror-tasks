require_relative "../controller/bank_transferer"
require_relative "../controller/stock_transactioner"

class VirtualWallet
  include BankTransferer
  include StockTransactioner

  # inicjalizacja klasy
    # w options możemy się spodziewać:
      # v_accounts: kont, które poda użytkownik,
      # v_external_bank: mocka do zewnętrznych serwisów obsługujących przelewy bankowe
      # v_external_stock_market: mock do zewnętrznych operacji giełdowych
  def initialize(options={})
    raise(IllegalArgument) unless options[:v_accounts]  # czy to wystarcza? nie trzeba nil?

    @accounts = []
    options[:v_accounts].each do |account|
      @accounts << Account.new(account)
    end

    @external_bank = options[:v_external_bank]
    @external_stock_market = options[:v_external_stock_market]
    @banks=[]
    @stocks=[]
    @rates=[]
    @stock_rates=[]
  end

  #funkcja do znajdywania konkretnego obiektu z podajen klasy
  def find(class_name, *params)
    case class_name
      when :account
        @accounts.find{|a| a.currency == params[0]} || raise(NonExistingObject)
      when :bank
        @banks.find{|b| b.name == params[0]} || raise(NonExistingObject)
      when :bank_restrict
        @banks.find{|br| br.name == params[0] && br.account_number == params[1]} || raise(NonExistingObject)
      when :rate
        @rates.find{|r| r.from_currency == params[0] && r.to_currency == params[1]} || raise(NonExistingObject)
      when :stock
        @stocks.find{|s| s.name == params[0]} || raise(NonExistingObject)
      when :stock_rate
        @stock_rates.find{|sr| sr.name == params[0]} || raise(NonExistingObject)
      else
        raise(IllegalArgument)
    end
  end

  # zwrócenie tablicy obiektów danej klasy
  attr_reader :accounts, :banks, :stocks, :rates, :stock_rates

  # dodanie do listy obiektów danej klasy nowej instancji tej klasy
  def add(class_name, *params)
    params.each do |param|
      raise(IllegalArgument) if param.nil?
    end

    case class_name
      when :bank
        params.each do |bank|

          begin
            self.find(:bank_restrict, bank.keys.first, bank.values.first) # czy jest już obiekt z takimi parametrami?
          rescue NonExistingObject
            @banks << Bank.new(bank)  # jeżeli nie to możemy dodać nowy
          end

        end
      else
        raise(IllegalArgument)
    end

  end

  def transfer_up(account, bank_name, money)
    if bank_transfer_up(money, bank_name)  #bank_transfer_up jest wczytany z modułu bank_trasnferer
      find(:account, account).money += money
    end
  end

  def transfer_back(account, bank_name, account_number, money)
    if bank_transfer_back(account_number, bank_name, money)  #bank_transfer_back jest wczytany z modułu bank_transferer
      find(:account, account).money -= money
    end
  end


  def check(param)
    check_out(param).to_s # from module StockTransactioner
  end


end